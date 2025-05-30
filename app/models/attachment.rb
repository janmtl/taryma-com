class Attachment < ActiveRecord::Base
  attr_accessible :artwork_id, :study_id, :position, :artwork_title
  belongs_to :artwork
  belongs_to :study
  
  validates_uniqueness_of :artwork_id, :scope => :study_id
  
  def artwork_title
    artwork.try(:title)
  end
  
  def artwork_title=(title)
    self.artwork = Artwork.find_by_title(title) if title.present?
  end
end
