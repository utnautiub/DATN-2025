class CreateRoomEquipments < ActiveRecord::Migration[8.0]
  def change
    create_table :room_equipments do |t|
      t.bigint :room_id
      t.string :name
      t.string :status
      t.timestamp :created_at
      t.timestamp :updated_at
      t.timestamp :deleted_at
    end
  end
end
