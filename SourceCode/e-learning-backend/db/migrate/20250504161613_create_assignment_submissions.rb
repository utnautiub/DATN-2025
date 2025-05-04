class CreateAssignmentSubmissions < ActiveRecord::Migration[8.0]
  def change
    create_table :assignment_submissions do |t|
      t.bigint :assignment_id
      t.bigint :student_id
      t.string :file_url
      t.string :file_name
      t.string :file_type
      t.integer :file_size
      t.timestamp :submitted_at
      t.integer :score
      t.text :feedback
      t.timestamp :created_at
      t.timestamp :updated_at
      t.timestamp :deleted_at
    end
  end
end
