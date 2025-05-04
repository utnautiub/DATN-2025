class User < ApplicationRecord
  belongs_to :school, optional: true
  has_many :teachers
  has_many :students
  has_many :forum_posts
  has_many :forum_replies
  has_many :chat_groups, foreign_key: :created_by
  has_many :chat_group_members
  has_many :chat_messages
  has_many :equipment_reports
end
