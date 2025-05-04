class CreateTrainingPrograms < ActiveRecord::Migration[8.0]
  def change
    create_table :training_programs do |t|
      t.bigint :major_id
      t.string :name
      t.integer :start_year
      t.integer :end_year
      t.timestamp :created_at
      t.timestamp :updated_at
      t.timestamp :deleted_at
    end
  end
end
