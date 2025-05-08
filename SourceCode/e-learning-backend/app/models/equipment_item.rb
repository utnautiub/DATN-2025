# app/models/equipment_item.rb
class EquipmentItem < ApplicationRecord
  belongs_to :room_equipment
  has_many :equipment_reports, dependent: :destroy

  validates :code, presence: true, uniqueness: true
  validates :status, presence: true, inclusion: { in: %w[Active Broken UnderRepair], message: 'must be Active, Broken, or UnderRepair' }
end