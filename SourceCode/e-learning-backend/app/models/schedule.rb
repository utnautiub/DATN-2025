class Schedule < ApplicationRecord
  belongs_to :course, optional: true
  belongs_to :school_class, class_name: 'Class', optional: true
  belongs_to :room, optional: true
  has_many :attendance_sessions, foreign_key: :schedule_id, inverse_of: :schedule
end