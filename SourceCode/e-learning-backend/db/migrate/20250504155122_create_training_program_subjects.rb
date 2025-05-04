class CreateTrainingProgramSubjects < ActiveRecord::Migration[8.0]
  def change
    create_table :training_program_subjects do |t|
      t.bigint :program_id
      t.bigint :subject_id
      t.integer :semester
      t.timestamp :created_at
      t.timestamp :updated_at
      t.timestamp :deleted_at
    end
  end
end
