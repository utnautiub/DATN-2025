class ForumAttachment < ApplicationRecord
  belongs_to :forum_post, optional: true
  belongs_to :forum_reply, optional: true
end