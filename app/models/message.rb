class Message < ActiveRecord::Base
  attr_accessible :content, :email, :from, :read, :date_created
  
  validates_presence_of :from, :message => "Must include a 'from' name"
  validates_presence_of :email, :message => "Must include an email address"
  validates_format_of :email, :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/, :message => "Must enter a valid email address"
end
