class Major < ApplicationRecord
  belongs_to :department
  has_many :students, dependent: :destroy
  has_many :training_programs, dependent: :destroy

  validates :name, presence: true
  validates :code, presence: true, uniqueness: { scope: :department_id }
end