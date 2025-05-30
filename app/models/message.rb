class Message < ActiveRecord::Base
  validates :from, presence: { message: "Must include a 'from' name" }
  validates :email, presence: { message: "Must include an email address" }
  validates :email, format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/, message: "Must enter a valid email address" }
end
