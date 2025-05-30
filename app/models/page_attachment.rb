class PageAttachment < ActiveRecord::Base
  belongs_to :image
  belongs_to :page

  validates :image_id, uniqueness: { scope: :page_id }

  def image_filename
    image&.filename
  end

  def image_filename=(filename)
    self.image = Image.find_by(filename: filename) if filename.present?
  end
end
