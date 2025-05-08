class RemoveQuantityAndStatusFromRoomEquipments < ActiveRecord::Migration[8.0]
  def change
    remove_column :room_equipments, :quantity, :integer
    remove_column :room_equipments, :status, :string
  end
end