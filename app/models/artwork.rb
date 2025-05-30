class Artwork < ActiveRecord::Base
  attr_accessible :catno, :date_created, :filename, :recent, :title, :xcm, :xinch, :ycm, :yinch, :technique_id, :category_id, :recent
  
  belongs_to :category
  belongs_to :technique
  
  mount_uploader :filename, FilenameUploader
  
  validates_associated :category
  validates_associated :technique
  
  def self.is_recent
    where("recent = 1 OR recent = ?", true)
  end
end
