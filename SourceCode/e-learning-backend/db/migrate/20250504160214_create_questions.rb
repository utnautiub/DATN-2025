class CreateQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :questions do |t|
      t.bigint :subject_id
      t.bigint :teacher_id
      t.boolean :is_public
      t.string :type
      t.text :content
      t.jsonb :options
      t.string :correct_answer
      t.integer :points
      t.timestamp :created_at
      t.timestamp :updated_at
      t.timestamp :deleted_at
    end
  end
end
