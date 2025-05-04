class Submission < ApplicationRecord
  belongs_to :exam
  belongs_to :student
  has_many :submission_answers
end