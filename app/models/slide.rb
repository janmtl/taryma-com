class Slide < ActiveRecord::Base
  belongs_to :artwork
  
  def artwork_title
    artwork&.title
  end
  
  def artwork_title=(title)
    self.artwork = Artwork.find_by(title: title) if title.present?
  end
end
