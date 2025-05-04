class EquipmentReport < ApplicationRecord
  belongs_to :room_equipment
  belongs_to :user
end