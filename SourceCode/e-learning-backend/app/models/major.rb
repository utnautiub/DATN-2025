class Major < ApplicationRecord
  belongs_to :department
  has_many :students
  has_many :training_programs
end