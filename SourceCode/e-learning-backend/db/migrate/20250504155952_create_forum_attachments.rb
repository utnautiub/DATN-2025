class CreateForumAttachments < ActiveRecord::Migration[8.0]
  def change
    create_table :forum_attachments do |t|
      t.bigint :post_id
      t.bigint :reply_id
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
