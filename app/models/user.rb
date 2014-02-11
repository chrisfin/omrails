class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :sex
  # attr_accessible :title, :body

  validates :name, presence: true
  validates :sex, presence: true

  has_many :pins
  has_many :views
  has_many :pins, :through => :views
  has_many :clicks
  has_many :pins, :through => :clicks

def self.list_admins
  t = true
  self.find(:all, :conditions => ['admin = ?', t])
end

end
