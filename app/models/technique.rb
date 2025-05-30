class Technique < ActiveRecord::Base
  attr_accessible :name, :position
  has_many :artworks, :dependent => :restrict
  validates_presence_of :name
  validates_presence_of :position, :numericality => { :only_integer => true }
end
