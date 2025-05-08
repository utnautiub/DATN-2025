class TrainingProgram < ApplicationRecord
  belongs_to :major
  has_many :training_program_subjects, dependent: :destroy
  has_many :students, dependent: :destroy

  validates :name, presence: true
  validates :start_year, presence: true, numericality: { greater_than: 2000 }
  validates :end_year, presence: true, numericality: { greater_than: :start_year }
end