class CreateExamSupervisors < ActiveRecord::Migration[8.0]
  def change
    create_table :exam_supervisors do |t|
      t.bigint :exam_room_id
      t.bigint :teacher_id
      t.timestamp :created_at
      t.timestamp :updated_at
      t.timestamp :deleted_at
    end
  end
end
