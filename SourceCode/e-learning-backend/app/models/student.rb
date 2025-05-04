class Student < ApplicationRecord
  belongs_to :user
  belongs_to :school_class, class_name: 'Class'
  belongs_to :major
  belongs_to :training_program
  has_many :enrollments
  has_many :submissions
  has_many :assignment_submissions
  has_many :exam_room_streams
  has_many :attendance_records
end