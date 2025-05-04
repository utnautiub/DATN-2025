class CreateForumReplies < ActiveRecord::Migration[8.0]
  def change
    create_table :forum_replies do |t|
      t.bigint :post_id
      t.bigint :user_id
      t.text :content
      t.timestamp :created_at
      t.timestamp :updated_at
      t.timestamp :deleted_at
    end
  end
end
