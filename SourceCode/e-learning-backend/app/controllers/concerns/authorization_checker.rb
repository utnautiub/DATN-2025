module AuthorizationChecker
  extend ActiveSupport::Concern

  # Kiểm tra quyền đối với một tài nguyên cụ thể
  def authorized_for_resource?(resource_type, resource_id, action)
    case resource_type
    when :school
      authorized_for_school?(resource_id, action)
    when :department
      authorized_for_department?(resource_id, action)
    when :class
      authorized_for_class?(resource_id, action)
    when :student
      authorized_for_student?(resource_id, action)
    when :teacher
      authorized_for_teacher?(resource_id, action)
    else
      false
    end
  end

  # Kiểm tra quyền trên một trường học
  def authorized_for_school?(school_id, action)
    return true if @current_user.role == "SuperAdmin"
    return @current_user.school_id == school_id.to_i if @current_user.role == "AdminSchools"
    false
  end

  # Kiểm tra quyền trên một khoa
  def authorized_for_department?(department_id, action)
    department = Department.find_by(id: department_id)
    return false unless department
    return true if @current_user.role == "SuperAdmin"
    return @current_user.school_id == department.school_id if @current_user.role == "AdminSchools"

    # Giáo viên trưởng khoa
    teacher = Teacher.find_by(user_id: @current_user.id)
    return teacher&.department_id == department_id.to_i if @current_user.role == "Teacher" && teacher

    false
  end

  # Kiểm tra quyền đối với một lớp
  def authorized_for_class?(class_id, action)
    class_obj = SchoolClass.find_by(id: class_id)
    return false unless class_obj
    return true if @current_user.role == "SuperAdmin"
    return @current_user.school_id == class_obj.school_id if @current_user.role == "AdminSchools"

    # Giáo viên chủ nhiệm
    return class_obj.homeroom_teacher_id == @current_user.id if @current_user.role == "Teacher"

    false
  end

  # Kiểm tra quyền đối với một học sinh
  def authorized_for_student?(student_id, action)
    student = Student.find_by(id: student_id)
    return false unless student
    user = User.find_by(id: student.user_id)
    return false unless user

    return true if @current_user.role == "SuperAdmin"
    return @current_user.school_id == user.school_id if @current_user.role == "AdminSchools"

    # Giáo viên chủ nhiệm
    school_class = SchoolClass.find_by(id: student.class_id)
    return school_class&.homeroom_teacher_id == @current_user.id if @current_user.role == "Teacher" && school_class

    # Học sinh chỉ có thể xem thông tin của chính mình
    return student.user_id == @current_user.id if @current_user.role == "Student" && action == :read

    false
  end

  # Kiểm tra quyền đối với một giáo viên
  def authorized_for_teacher?(teacher_id, action)
    teacher = Teacher.find_by(id: teacher_id)
    return false unless teacher
    user = User.find_by(id: teacher.user_id)
    return false unless user

    return true if @current_user.role == "SuperAdmin"
    return @current_user.school_id == user.school_id if @current_user.role == "AdminSchools"

    # Giáo viên trưởng khoa
    current_teacher = Teacher.find_by(user_id: @current_user.id)
    return current_teacher&.department_id == teacher.department_id if @current_user.role == "Teacher" && current_teacher && current_teacher.is_head

    # Giáo viên chỉ có thể xem thông tin của chính mình
    return teacher.user_id == @current_user.id if @current_user.role == "Teacher" && action == :read

    false
  end
end
