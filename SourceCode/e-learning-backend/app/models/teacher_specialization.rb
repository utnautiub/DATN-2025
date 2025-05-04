class TeacherSpecialization < ApplicationRecord
  belongs_to :teacher
  belongs_to :specialization
end