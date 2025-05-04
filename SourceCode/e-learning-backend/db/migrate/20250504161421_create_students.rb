class CreateStudents < ActiveRecord::Migration[8.0]
  def change
    create_table :students do |t|
      t.bigint :user_id
      t.bigint :class_id
      t.bigint :major_id
      t.bigint :program_id
      t.string :name
      t.string :email
      t.string :phone
      t.timestamp :created_at
      t.timestamp :updated_at
      t.timestamp :deleted_at
    end
  end
end
