class Room < ApplicationRecord
  belongs_to :building
  has_many :room_equipments
  has_many :equipment_reports, through: :room_equipments
  has_many :schedules

  validates :name, presence: true
  validates :capacity, presence: true, numericality: { greater_than: 0 }

  # Định nghĩa phương thức để lấy school_id thông qua building
  def school_id
    building&.school_id
  end
end