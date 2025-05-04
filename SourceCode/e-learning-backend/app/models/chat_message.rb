class ChatMessage < ApplicationRecord
  belongs_to :chat_group
  belongs_to :user
  has_many :chat_message_attachments
end