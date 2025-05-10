class TeacherValidatorService
  attr_reader :params, :current_user, :errors

  def initialize(params, current_user)
    @params = params
    @current_user = current_user
    @errors = []
  end

  def valid_homeroom_teacher?
    return true unless params[:homeroom_teacher_id].present?

    # Tìm người dùng với id và role Teacher
    teacher = User.unscope(where: :deleted_at).find_by(id: params[:homeroom_teacher_id], role: "Teacher")
    unless teacher
      @errors << "Giáo viên chủ nhiệm không tồn tại"
      return false
    end

    # Kiểm tra xem giáo viên có bị xóa mềm hay không
    if teacher.deleted?
      @errors << "Giáo viên chủ nhiệm đã bị xóa"
      return false
    end

    # Kiểm tra xem có bản ghi trong bảng teachers với user_id tương ứng không
    teacher_record = Teacher.unscope(where: :deleted_at).find_by(user_id: params[:homeroom_teacher_id])
    unless teacher_record
      @errors << "Giáo viên không có thông tin trong bảng teachers"
      return false
    end

    # Kiểm tra xem bản ghi trong teachers có bị xóa mềm hay không
    if teacher_record.deleted?
      @errors << "Thông tin giáo viên trong bảng teachers đã bị xóa"
      return false
    end

    # Kiểm tra xem giáo viên đã được gán cho lớp khác chưa
    existing_class = SchoolClass.where(homeroom_teacher_id: params[:homeroom_teacher_id], school_id: current_user.school_id)
                               .where.not(id: params[:id])
    if existing_class.exists?
      @errors << "Giáo viên này đã được gán cho một lớp khác"
      return false
    end

    true
  end
end
