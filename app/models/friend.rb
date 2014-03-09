class Friend < ActiveRecord::Base
  attr_accessible :uid, :screen_name, :location, :profile_image_url, :authentication_id
  belongs_to :authentications
end
