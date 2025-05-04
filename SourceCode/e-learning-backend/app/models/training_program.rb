class TrainingProgram < ApplicationRecord
  belongs_to :major
  has_many :training_program_subjects
  has_many :students
end