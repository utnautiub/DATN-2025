class RoomEquipment < ApplicationRecord
  belongs_to :room
  has_many :equipment_items, dependent: :destroy
  has_many :equipment_reports, through: :equipment_items

  validates :name, presence: true

  attr_accessor :quantity 

  before_create :generate_equipment_items

  private

  def generate_equipment_items
    qty = self.quantity || 1
    (1..qty).each do |i|
      code = generate_unique_code
      equipment_items.build(code: code, status: 'Active')
    end
  end

  def generate_unique_code
    loop do
      code = "EQ#{SecureRandom.alphanumeric(8).upcase}"
      break code unless EquipmentItem.exists?(code: code)
    end
  end
end