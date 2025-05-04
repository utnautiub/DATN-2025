class Assignment < ApplicationRecord
  belongs_to :course
  belongs_to :teacher
  has_many :assignment_submissions
end