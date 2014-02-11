class Click < ActiveRecord::Base
  # attr_accessible :title, :body

	belongs_to :user
	belongs_to :pin

def self.admin_clicks(admins)
    self.find(:all, :conditions => ['user_id in (?)', admins])
  end

  def self.real_user_clicks(admins)
    self.find(:all, :conditions => ['user_id not in (?)', admins])
  end

  def self.real_user_shops(admins)
     self.find(:all, :conditions => ["place = 'shop' AND user_id not in (?)", admins])
  end



end
