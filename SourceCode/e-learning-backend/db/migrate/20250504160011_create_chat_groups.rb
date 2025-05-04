class CreateChatGroups < ActiveRecord::Migration[8.0]
  def change
    create_table :chat_groups do |t|
      t.bigint :class_id
      t.bigint :course_id
      t.bigint :created_by
      t.string :name
      t.timestamp :created_at
      t.timestamp :updated_at
      t.timestamp :deleted_at
    end
  end
end
