class AddProviderToAuthentications < ActiveRecord::Migration
  def change
  	add_column :authentications, :user_id, :string
  	add_column :authentications, :provider, :string
  	add_column :authentications, :uid, :string
  	add_column :authentications, :token, :string
  	add_column :authentications, :token_secret, :string
  end
end
