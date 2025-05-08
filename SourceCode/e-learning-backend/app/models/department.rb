class Department < ApplicationRecord
  belongs_to :school
  has_many :majors, dependent: :destroy
  has_many :teachers, dependent: :destroy

  validates :name, presence: true
  validates :code, presence: true, uniqueness: { scope: :school_id }
end