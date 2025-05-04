class Forum < ApplicationRecord
  belongs_to :school_class, class_name: 'Class', optional: true
  belongs_to :course, optional: true
  has_many :forum_posts
end