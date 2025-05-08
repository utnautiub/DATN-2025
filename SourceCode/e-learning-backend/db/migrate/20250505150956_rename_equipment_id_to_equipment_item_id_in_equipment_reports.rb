class RenameEquipmentIdToEquipmentItemIdInEquipmentReports < ActiveRecord::Migration[8.0]
  def change
    rename_column :equipment_reports, :equipment_id, :equipment_item_id
  end
end