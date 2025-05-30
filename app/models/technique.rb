class Technique < ActiveRecord::Base
  has_many :artworks, :dependent => :restrict
  validates :name, presence: true
  validates :position, presence: true, numericality: { only_integer: true }
end
