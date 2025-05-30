class User < ActiveRecord::Base
  authenticates_with_sorcery!
  
  validates :password, presence: true, confirmation: true
  validates :username, presence: true, uniqueness: true
end
