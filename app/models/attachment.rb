class Attachment < ActiveRecord::Base
  belongs_to :artwork
  belongs_to :study

  validates :artwork_id, uniqueness: { scope: :study_id }

  def artwork_title
    artwork&.title
  end

  def artwork_title=(title)
    self.artwork = Artwork.find_by(title: title) if title.present?
  end
end
