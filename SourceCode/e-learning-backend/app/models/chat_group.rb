class ChatGroup < ApplicationRecord
  belongs_to :school_class, class_name: 'Class', optional: true
  belongs_to :course, optional: true
  belongs_to :created_by, class_name: 'User', optional: true
  has_many :chat_group_members
  has_many :chat_messages, foreign_key: :chat_group_id, inverse_of: :chat_group
end