class CreateClassMaterials < ActiveRecord::Migration[8.0]
  def change
    create_table :class_materials do |t|
      t.bigint :class_id
      t.bigint :course_id
      t.bigint :teacher_id
      t.string :title
      t.text :description
      t.string :material_type
      t.string :file_url
      t.string :file_name
      t.string :file_type
      t.integer :file_size
      t.timestamp :uploaded_at
      t.timestamp :created_at
      t.timestamp :updated_at
      t.timestamp :deleted_at
    end
  end
end
