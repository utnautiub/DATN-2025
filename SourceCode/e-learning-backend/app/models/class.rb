class Class < ApplicationRecord
  belongs_to :school
  belongs_to :homeroom_teacher, class_name: 'Teacher'
  has_many :students, foreign_key: :class_id, inverse_of: :school_class
  has_many :schedules, foreign_key: :class_id, inverse_of: :school_class
  has_many :forums, foreign_key: :class_id, inverse_of: :school_class
  has_many :chat_groups, foreign_key: :class_id, inverse_of: :school_class
  has_many :class_materials, foreign_key: :class_id, inverse_of: :school_class
end