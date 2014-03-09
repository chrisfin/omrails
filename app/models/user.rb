class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable, :recoverable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :sex
  # attr_accessible :title, :body

  validates :name, presence: true
  validates :sex, presence: true

  has_many :pins
  has_many :views, dependent: :destroy
  has_many :pins, :through => :views
  has_many :clicks, dependent: :destroy
  has_many :pins, :through => :clicks
  has_many :authentications
  has_many :friends, :through => :authentications

  def self.list_admins
    t = true
    self.find(:all, :conditions => ['admin = ?', t])
  end

  def apply_omniauth(omni)
    authentications.build(:provider => omni['provider'],
    :uid => omni['uid'],
    :token => omni['credentials'].token,
    :token_secret => omni['credentials'].secret)
  end
end
