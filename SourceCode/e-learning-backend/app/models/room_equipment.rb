class RoomEquipment < ApplicationRecord
  belongs_to :room
  has_many :equipment_reports
end