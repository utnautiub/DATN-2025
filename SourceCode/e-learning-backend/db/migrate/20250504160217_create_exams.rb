class CreateExams < ActiveRecord::Migration[8.0]
  def change
    create_table :exams do |t|
      t.bigint :course_id
      t.bigint :teacher_id
      t.string :exam_code
      t.boolean :is_public
      t.string :title
      t.string :type
      t.timestamp :start_time
      t.timestamp :end_time
      t.integer :duration
      t.integer :total_points
      t.timestamp :created_at
      t.timestamp :updated_at
      t.timestamp :deleted_at
    end
  end
end
