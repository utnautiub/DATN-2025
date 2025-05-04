class CreateSchedules < ActiveRecord::Migration[8.0]
  def change
    create_table :schedules do |t|
      t.bigint :course_id
      t.bigint :class_id
      t.string :day_of_week
      t.time :start_time
      t.time :end_time
      t.bigint :room_id
      t.string :meet_link
      t.string :status
      t.timestamp :created_at
      t.timestamp :updated_at
      t.timestamp :deleted_at
    end
  end
end
