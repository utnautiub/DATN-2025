class CreateSubmissions < ActiveRecord::Migration[8.0]
  def change
    create_table :submissions do |t|
      t.bigint :exam_id
      t.bigint :student_id
      t.timestamp :started_at
      t.timestamp :submitted_at
      t.integer :score
      t.text :feedback
      t.timestamp :created_at
      t.timestamp :updated_at
      t.timestamp :deleted_at
    end
  end
end
