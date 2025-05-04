class ExamSupervisor < ApplicationRecord
  belongs_to :exam_room
  belongs_to :teacher
end