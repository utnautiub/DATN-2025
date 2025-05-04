class ForumReply < ApplicationRecord
  belongs_to :forum_post
  belongs_to :user
  has_many :forum_attachments
end