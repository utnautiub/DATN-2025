class AddCodeToDepartmentsAndMajors < ActiveRecord::Migration[8.0]
  def change
    add_column :departments, :code, :string
    add_column :majors, :code, :string
    add_column :students, :student_code, :string
    add_column :teachers, :teacher_code, :string

    add_index :students, :student_code, unique: true
    add_index :teachers, :teacher_code, unique: true
  end
end
