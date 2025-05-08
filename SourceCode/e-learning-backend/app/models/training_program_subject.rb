class TrainingProgramSubject < ApplicationRecord
  belongs_to :training_program, foreign_key: 'program_id' # Chỉ định đúng cột khóa ngoại
  belongs_to :subject

  validates :program_id, presence: true
  validates :subject_id, presence: true
  validates :semester, presence: true, numericality: { greater_than: 0 }
end