class View < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  belongs_to :pin

  validates :rank, presence: true


  def self.user_views(user)
   where(user_id: user.id)
  end

	def self.user_liked(user)
  	self.find(:all, :conditions => ['rank = 1 AND user_id = ?', user])
  end

  def self.views_today(user)
    date = Time.now
    now = date.at_beginning_of_day
    views = self.find(:all, :conditions => ['user_id = ? AND created_at > ?', user, now ])
  end

    def self.yes_views_today(user)
    date = Time.now
    now = date.at_beginning_of_day
    views = self.find(:all, :conditions => ['rank = 1 AND user_id = ? AND created_at > ?', user, now ])
  end

  def self.last_view(user)
    self.last(:conditions => ['user_id = ?', user], :order => "id desc", :limit => 1)
  end

  def self.admin_views(admins)
    self.find(:all, :conditions => ['user_id in (?)', admins])
  end

  def self.real_user_views(admins)
    self.find(:all, :conditions => ['user_id not in (?)', admins])
  end

  def self.real_user_yes(admins)
     self.find(:all, :conditions => ['rank = 1 AND user_id not in (?)', admins])
  end

end
