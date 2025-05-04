class ExamRoom < ApplicationRecord
  belongs_to :exam
  belongs_to :room, optional: true
  has_many :exam_supervisors
  has_many :exam_room_streams
end