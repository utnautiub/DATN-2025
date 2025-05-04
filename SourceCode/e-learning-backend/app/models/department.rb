class Department < ApplicationRecord
  belongs_to :school
  has_many :majors
  has_many :teachers
end