class CreateAttendanceRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :attendance_records do |t|
      t.bigint :session_id
      t.bigint :student_id
      t.decimal :latitude
      t.decimal :longitude
      t.timestamp :timestamp
      t.string :method
      t.boolean :is_valid
      t.timestamp :created_at
      t.timestamp :updated_at
      t.timestamp :deleted_at
    end
  end
end
