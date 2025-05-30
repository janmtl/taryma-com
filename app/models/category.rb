class Category < ActiveRecord::Base
  has_many :artworks, dependent: :restrict_with_error
  validates :name, presence: true
  validates :position, presence: true, numericality: { only_integer: true }
end
