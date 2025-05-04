class AttendanceSession < ApplicationRecord
  belongs_to :schedule
  has_many :attendance_records
end