class Slide < ActiveRecord::Base
  attr_accessible :artwork_id, :position, :artwork_title
  
  belongs_to :artwork
  
  #acts_as_list
  
  def artwork_title
    artwork.try(:title)
  end
  
  def artwork_title=(title)
    self.artwork = Artwork.find_by_title(title) if title.present?
  end
end
