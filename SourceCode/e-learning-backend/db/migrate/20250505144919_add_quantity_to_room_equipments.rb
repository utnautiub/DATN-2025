class AddQuantityToRoomEquipments < ActiveRecord::Migration[8.0]
  def change
    add_column :room_equipments, :quantity, :integer
  end
end
