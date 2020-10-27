class User < ApplicationRecord
  has_secure_password
  validates_presence_of :name, :street_address, :city, :state, :zip, :email, :password   
  validates :email, uniqueness: true, presence: true

  def email_exists?
    User.exists?(email: self.email)
  end
end
