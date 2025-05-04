class School < ApplicationRecord
  has_many :buildings
  has_many :departments
  has_many :classes
  has_many :courses
  has_many :users
  has_many :subject_assignments
end