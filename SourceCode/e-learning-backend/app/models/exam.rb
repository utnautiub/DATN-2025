class Exam < ApplicationRecord
  belongs_to :course
  belongs_to :teacher
  has_many :exam_questions
  has_many :submissions
  has_many :exam_rooms
end