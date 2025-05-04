class Course < ApplicationRecord
  belongs_to :school
  belongs_to :subject
  belongs_to :teacher
  has_many :schedules
  has_many :enrollments
  has_many :forums
  has_many :chat_groups
  has_many :class_materials
  has_many :exams
  has_many :assignments
end