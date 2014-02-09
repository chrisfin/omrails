class View < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  belongs_to :pin

  validates :rank, presence: true


  def self.user_views(user)
  	self.find(:all, :conditions => ['user_id = ?', user])
  end

	def self.user_liked(user)
  	self.find(:all, :conditions => ['rank = 1 AND user_id = ?', user])
  end

  def self.views_today(user)
    date = Time.now
    now = date.at_beginning_of_day
    views = self.find(:all, :conditions => ['user_id = ? AND created_at > ?', user, now ])


  end

end
