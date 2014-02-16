class Brand < ActiveRecord::Base
  has_many :pins
  attr_accessible :image, :name, :url

  has_attached_file :image, styles: { small: "250x75>", tiny: "70x25>"}
  
  validates_attachment :image, presence: true,
                            content_type: { content_type: ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'] },
                            size: { less_than: 5.megabytes }

  validates :name, uniqueness: true
end
