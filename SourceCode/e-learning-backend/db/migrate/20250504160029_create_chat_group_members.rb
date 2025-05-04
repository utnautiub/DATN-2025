class CreateChatGroupMembers < ActiveRecord::Migration[8.0]
  def change
    create_table :chat_group_members do |t|
      t.bigint :chat_group_id
      t.bigint :user_id
      t.timestamp :joined_at
      t.timestamp :created_at
      t.timestamp :updated_at
      t.timestamp :deleted_at
    end
  end
end
