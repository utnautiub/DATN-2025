class CreateEquipmentItems < ActiveRecord::Migration[8.0]
  def change
    create_table :equipment_items do |t|
      t.references :room_equipment, null: false, foreign_key: true
      t.string :code, null: false
      t.string :status, null: false, default: 'Active'
      t.timestamps
    end

    add_index :equipment_items, :code, unique: true
  end
end