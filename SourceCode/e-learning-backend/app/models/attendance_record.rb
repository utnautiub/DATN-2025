class AttendanceRecord < ApplicationRecord
  belongs_to :attendance_session
  belongs_to :student
end