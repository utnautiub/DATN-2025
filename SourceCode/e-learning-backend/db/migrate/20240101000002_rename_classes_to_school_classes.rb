class RenameClassesToSchoolClasses < ActiveRecord::Migration[7.0]
  def change
    rename_table :classes, :school_classes
  end
end