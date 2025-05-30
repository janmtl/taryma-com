class Page < ActiveRecord::Base
  attr_accessible :content, :title, :slug, :page_attachments_attributes

  validates :slug, :presence => true
  
  has_many :page_attachments, :dependent => :destroy
  has_many :images, :through => :page_attachments
  
  accepts_nested_attributes_for :page_attachments, :allow_destroy => true, :reject_if => lambda { |a| a[:image_id].blank? }
end
