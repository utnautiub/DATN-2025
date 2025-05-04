class CreateSubjectAssignments < ActiveRecord::Migration[8.0]
  def change
    create_table :subject_assignments do |t|
      t.bigint :subject_id
      t.bigint :teacher_id
      t.bigint :school_id
      t.timestamp :created_at
      t.timestamp :updated_at
      t.timestamp :deleted_at
    end
  end
end
