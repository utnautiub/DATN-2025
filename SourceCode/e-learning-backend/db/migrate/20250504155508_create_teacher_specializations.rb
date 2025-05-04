class CreateTeacherSpecializations < ActiveRecord::Migration[8.0]
  def change
    create_table :teacher_specializations do |t|
      t.bigint :teacher_id
      t.bigint :specialization_id
      t.timestamp :created_at
      t.timestamp :updated_at
      t.timestamp :deleted_at
    end
  end
end
