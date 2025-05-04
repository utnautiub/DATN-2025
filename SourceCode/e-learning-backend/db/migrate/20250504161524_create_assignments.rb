class CreateAssignments < ActiveRecord::Migration[8.0]
  def change
    create_table :assignments do |t|
      t.bigint :course_id
      t.bigint :teacher_id
      t.string :title
      t.text :description
      t.timestamp :deadline
      t.integer :max_points
      t.timestamp :created_at
      t.timestamp :updated_at
      t.timestamp :deleted_at
    end
  end
end
