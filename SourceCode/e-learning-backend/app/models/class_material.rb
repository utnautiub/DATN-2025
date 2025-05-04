class ClassMaterial < ApplicationRecord
  belongs_to :school_class, class_name: 'Class', optional: true
  belongs_to :course, optional: true
  belongs_to :teacher
end