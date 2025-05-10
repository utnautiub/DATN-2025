class UserRegistrationService
  attr_reader :params, :current_user, :errors

  def initialize(params, current_user)
    @params = params
    @current_user = current_user
    @errors = []
  end

  def register
    user = User.new(user_params.merge(school_id: current_user.school_id))
    user.role = params[:role] if params[:role].present?

    # Xử lý Student
    if user.role == "Student" && params[:student].present?
      student_params = params.require(:student).permit(:department_id, :major_id, :class_id, :training_program_id)
      student = Student.new(student_params)
      user.student = student
    end

    # Xử lý Teacher
    if user.role == "Teacher" && params[:teacher].present?
      teacher_params = params.require(:teacher).permit(:department_id)
      teacher = Teacher.new(teacher_params)
      user.teacher = teacher
    end

    return false unless user.save

    # Tạo mã tự động cho Student hoặc Teacher
    if user.student
      user.student.update(student_code: "STU#{format('%06d', user.student.id)}")
    elsif user.teacher
      user.teacher.update(teacher_code: "TCH#{format('%06d', user.teacher.id)}")
      # Gán môn học (chuyên môn) cho giáo viên thông qua subject_assignments
      if params[:teacher].present? && params[:teacher][:subject_id].present?
        SubjectAssignment.create!(
          school_id: current_user.school_id,
          teacher_id: user.teacher.id,
          subject_id: params[:teacher][:subject_id]
        )
      end
    end

    user
  rescue => e
    @errors << e.message
    false
  end

  private

  def user_params
    params.permit(:username, :password, :role)
  end
end
