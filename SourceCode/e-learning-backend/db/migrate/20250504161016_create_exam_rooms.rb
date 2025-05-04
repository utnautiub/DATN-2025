class CreateExamRooms < ActiveRecord::Migration[8.0]
  def change
    create_table :exam_rooms do |t|
      t.bigint :exam_id
      t.bigint :room_id
      t.string :type
      t.timestamp :created_at
      t.timestamp :updated_at
      t.timestamp :deleted_at
    end
  end
end
