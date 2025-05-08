class EquipmentReport < ApplicationRecord
  belongs_to :equipment_item
  belongs_to :user

  validates :description, presence: true
  validates :status, presence: true, inclusion: { in: %w[Pending InProgress Resolved], message: 'must be Pending, InProgress, or Resolved' }
end