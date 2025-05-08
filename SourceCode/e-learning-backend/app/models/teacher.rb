# app/models/teacher.rb
class Teacher < ApplicationRecord
  belongs_to :user
  belongs_to :department
  has_many :classes, foreign_key: :homeroom_teacher_id
  has_many :courses
  has_many :teacher_specializations
  has_many :subject_assignments
  has_many :subjects, through: :subject_assignments
  has_many :class_materials
  has_many :questions
  has_many :exams
  has_many :exam_supervisors

  validates :teacher_code, uniqueness: true, allow_nil: true

  before_create :generate_teacher_code

  private

  def generate_teacher_code
    return unless department

    # Lấy mã khoa
    department_code = department.code

    # Tạo số ngẫu nhiên không trùng (3 chữ số)
    loop do
      random_number = format("%03d", rand(1..999))
      self.teacher_code = "#{department_code}#{random_number}"
      break unless Teacher.exists?(teacher_code: teacher_code)
    end
  end
end
