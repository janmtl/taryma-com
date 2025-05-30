class Image < ActiveRecord::Base
  attr_accessible :filename, :description
  
  mount_uploader :filename, FilenameUploader
end
