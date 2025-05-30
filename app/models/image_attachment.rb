class ImageAttachment < ActiveRecord::Base
  attr_accessible :image_id, :position, :study_id, :image_filename
  belongs_to :image
  belongs_to :study
  
  validates_uniqueness_of :image_id, :scope => :study_id
  
  def image_filename
    image.try(:filename)
  end
  
  def image_filename=(filename)
    self.image = Image.find_by_filename(filename) if filename.present?
  end
end
