class School < ApplicationRecord
  has_many :buildings
  has_many :departments
  has_many :school_classes
  has_many :courses
  has_many :users
  has_many :subject_assignments
  
  # Thêm các phương thức để lấy teachers và students
  def teachers
    User.where(school_id: id, role: 'Teacher')
  end
  
  def students
    User.where(school_id: id, role: 'Student')
  end
end
