class CreateCourses < ActiveRecord::Migration[8.0]
  def change
    create_table :courses do |t|
      t.bigint :school_id
      t.bigint :subject_id
      t.bigint :teacher_id
      t.string :name
      t.string :mode
      t.timestamp :created_at
      t.timestamp :updated_at
      t.timestamp :deleted_at
    end
  end
end
