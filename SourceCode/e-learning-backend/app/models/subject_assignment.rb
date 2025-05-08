class SubjectAssignment < ApplicationRecord
  belongs_to :subject
  belongs_to :teacher
  belongs_to :school

  validates :subject_id, presence: true
  validates :teacher_id, presence: true
  validates :school_id, presence: true
end