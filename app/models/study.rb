class Study < ActiveRecord::Base
  # attr_accessible :description, :name, :position, :attachments_attributes, :image_attachments_attributes
  
  has_many :attachments, dependent: :destroy
  has_many :artworks, through: :attachments
  
  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: ->(a) { a[:artwork_id].blank? }

  has_many :image_attachments, dependent: :destroy
  has_many :images, through: :image_attachments
  
  accepts_nested_attributes_for :image_attachments, allow_destroy: true, reject_if: ->(a) { a[:image_id].blank? }
end