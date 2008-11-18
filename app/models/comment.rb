class Comment < ActiveRecord::Base
  belongs_to :picture

  validates_presence_of :author, :email, :body, :ip, :picture_id
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_associated :picture
  validate :picture_exist

private

  def picture_exist
    Picture.find(self.picture_id).nil?
  rescue ActiveRecord::RecordNotFound
    errors.add(:picture, 'You need use a picture existing')
  end

end
