class CreateAttendanceSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :attendance_sessions do |t|
      t.bigint :schedule_id
      t.string :qr_code
      t.timestamp :start_time
      t.timestamp :end_time
      t.integer :gps_range
      t.timestamp :created_at
      t.timestamp :updated_at
      t.timestamp :deleted_at
    end
  end
end
