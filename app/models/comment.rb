class Comment < ActiveRecord::Base
  belongs_to :picture

  validates_presence_of :author, :email, :body, :ip, :picture_id
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
end
