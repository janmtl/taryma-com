class PageAttachment < ActiveRecord::Base
  attr_accessible :image_id, :position, :page_id, :image_filename
  belongs_to :image
  belongs_to :page
  
  validates_uniqueness_of :image_id, :scope => :page_id
  
  def image_filename
    image.try(:filename)
  end
  
  def image_filename=(filename)
    self.image = Image.find_by_filename(filename) if filename.present?
  end
end
