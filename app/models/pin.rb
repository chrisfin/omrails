class Pin < ActiveRecord::Base
  attr_accessible :description, :image, :image_remote_url, :product_url, :price, :brand, :item_type, :active, :sex

  has_attached_file :image, styles: { large: "400x400>", thumb: "100x100>"}
  
  validates_attachment :image, presence: true,
                            content_type: { content_type: ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'] },
                            size: { less_than: 5.megabytes }
  validates :product_url, presence: true
  validates :brand, presence: true
  validates :price, presence: true
  validates :item_type, presence: true
  validates :sex, presence: true

  belongs_to :user
  has_many :views
  has_many :users, :through => :views
  has_many :clicks
  has_many :users, :through => :clicks

  
  def image_remote_url=(url_value)
  	self.image = URI.parse(url_value) unless url_value.blank?	
  	super
  end
  
  def self.new_pin(pin_ids)
      b = TRUE
      self.find(:first, :conditions => ["active = ? AND id not in (?)", b, pin_ids], :order => "id desc" )
  end

  def self.user_pins(pin_ids)
      b = TRUE
      self.find(:all, :conditions => ["active = ? AND id in (?)", b, pin_ids])
  end

  def self.percent_yes
      pinview = self.views
      total = pinview.count
      yes = pinview.find(:all, :conditions => ["rank = ?", 1]).count
      return
      yes / total
    
  end

  def self.all_new_pins(pin_ids, sex)
      b = TRUE
      self.find(:all, :conditions => ["active = ? AND sex = ? AND id not in (?)", b, sex, pin_ids])
  end

  def self.active_pins
    b = TRUE
    self.find(:all, :conditions => ["active = ?", b])
  end



end
