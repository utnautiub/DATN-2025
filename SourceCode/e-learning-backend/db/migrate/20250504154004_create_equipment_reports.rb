class CreateEquipmentReports < ActiveRecord::Migration[8.0]
  def change
    create_table :equipment_reports do |t|
      t.bigint :equipment_id
      t.bigint :user_id
      t.text :description
      t.string :status
      t.timestamp :created_at
      t.timestamp :updated_at
      t.timestamp :deleted_at
    end
  end
end
