class CreateSubmissionAnswers < ActiveRecord::Migration[8.0]
  def change
    create_table :submission_answers do |t|
      t.bigint :submission_id
      t.bigint :question_id
      t.text :answer
      t.integer :score
      t.timestamp :created_at
      t.timestamp :updated_at
      t.timestamp :deleted_at
    end
  end
end
