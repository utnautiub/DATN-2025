class Teacher < ApplicationRecord
  belongs_to :user
  belongs_to :department
  has_many :classes, foreign_key: :homeroom_teacher_id
  has_many :courses
  has_many :teacher_specializations
  has_many :subject_assignments
  has_many :class_materials
  has_many :questions
  has_many :exams
  has_many :exam_supervisors
end