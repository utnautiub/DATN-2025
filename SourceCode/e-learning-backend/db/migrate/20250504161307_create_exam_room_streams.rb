class CreateExamRoomStreams < ActiveRecord::Migration[8.0]
  def change
    create_table :exam_room_streams do |t|
      t.bigint :exam_room_id
      t.bigint :student_id
      t.string :stream_url
      t.timestamp :started_at
      t.timestamp :ended_at
      t.timestamp :created_at
      t.timestamp :updated_at
      t.timestamp :deleted_at
    end
  end
end
