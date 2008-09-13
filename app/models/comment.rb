class Comment < ActiveRecord::Base
  belongs_to :picture

  validates_presence_of :author, :email, :body, :ip, :picture_id
end
