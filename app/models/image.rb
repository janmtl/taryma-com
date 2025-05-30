class Image < ActiveRecord::Base
  mount_uploader :filename, FilenameUploader
end
