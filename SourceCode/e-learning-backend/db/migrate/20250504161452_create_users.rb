class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.bigint :school_id
      t.string :username
      t.string :password
      t.string :role
      t.string :admin_level
      t.string :google_access_token
      t.string :google_refresh_token
      t.timestamp :google_token_expiry
      t.timestamp :created_at
      t.timestamp :updated_at
      t.timestamp :deleted_at
    end
  end
end
