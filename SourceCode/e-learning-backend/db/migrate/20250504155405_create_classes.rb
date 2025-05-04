class CreateClasses < ActiveRecord::Migration[8.0]
  def change
    create_table :classes do |t|
      t.bigint :school_id
      t.string :name
      t.bigint :homeroom_teacher_id
      t.timestamp :created_at
      t.timestamp :updated_at
      t.timestamp :deleted_at
    end
  end
end
