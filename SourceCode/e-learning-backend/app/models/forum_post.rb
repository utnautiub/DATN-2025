class ForumPost < ApplicationRecord
  belongs_to :forum
  belongs_to :user
  has_many :forum_replies
  has_many :forum_attachments
end