class AddStuffToFriends < ActiveRecord::Migration
  def change
  	add_column :friends, :authentication_id, :string
  	add_column :friends, :uid, :string
  	add_column :friends, :screen_name, :string
  	add_column :friends, :location, :string
  	add_column :friends, :profile_image_url, :string
  end
end
