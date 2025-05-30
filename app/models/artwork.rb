class Artwork < ActiveRecord::Base
  belongs_to :category
  belongs_to :technique

  mount_uploader :filename, FilenameUploader

  validates :category, presence: true
  validates :technique, presence: true

  def self.is_recent
    where("recent = ? OR recent = ?", 1, true)
  end
end
