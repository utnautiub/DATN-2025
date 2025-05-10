# app/models/student.rb
class Student < ApplicationRecord
  acts_as_paranoid
  belongs_to :user
  belongs_to :school_class, foreign_key: :class_id
  belongs_to :major, optional: true
  belongs_to :training_program, optional: true
  has_many :enrollments
  has_many :submissions
  has_many :assignment_submissions
  has_many :exam_room_streams
  has_many :attendance_records

  validates :student_code, uniqueness: true, allow_nil: true

  before_create :generate_student_code

  default_scope { where(deleted_at: nil) }
  scope :with_deleted, -> { unscope(where: :deleted_at).where.not(deleted_at: nil) }

  private

  def generate_student_code
    return unless major && training_program

    # Lấy mã ngành và năm học
    major_code = major.code
    year = training_program.start_year.to_s

    # Tạo số ngẫu nhiên không trùng (4 chữ số)
    loop do
      random_number = format("%04d", rand(1..9999))
      self.student_code = "#{major_code}#{year}#{random_number}"
      break unless Student.exists?(student_code: student_code)
    end
  end
end
