class ExamRoomStream < ApplicationRecord
  belongs_to :exam_room
  belongs_to :student
end