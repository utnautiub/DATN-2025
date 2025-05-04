class CreateMajors < ActiveRecord::Migration[8.0]
  def change
    create_table :majors do |t|
      t.bigint :department_id
      t.string :name
      t.timestamp :created_at
      t.timestamp :updated_at
      t.timestamp :deleted_at
    end
  end
end
