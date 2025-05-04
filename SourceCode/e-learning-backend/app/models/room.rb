class Room < ApplicationRecord
  belongs_to :building
  has_many :room_equipments
  has_many :schedules
  has_many :exam_rooms
end