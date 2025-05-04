class CreateChatMessageAttachments < ActiveRecord::Migration[8.0]
  def change
    create_table :chat_message_attachments do |t|
      t.bigint :message_id
      t.string :file_url
      t.string :file_name
      t.string :file_type
      t.integer :file_size
      t.timestamp :uploaded_at
      t.timestamp :created_at
      t.timestamp :updated_at
      t.timestamp :deleted_at
    end
  end
end
