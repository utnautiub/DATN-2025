class CreateExamQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :exam_questions do |t|
      t.bigint :exam_id
      t.bigint :question_id
      t.integer :order
      t.integer :points
      t.timestamp :created_at
      t.timestamp :updated_at
      t.timestamp :deleted_at
    end
  end
end
