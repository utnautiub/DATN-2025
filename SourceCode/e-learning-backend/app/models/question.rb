class Question < ApplicationRecord
  belongs_to :subject
  belongs_to :teacher
  has_many :exam_questions
  has_many :submission_answers
end