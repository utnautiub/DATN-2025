class Subject < ApplicationRecord
  has_many :training_program_subjects
  has_many :courses
  has_many :questions
  has_many :subject_assignments
end