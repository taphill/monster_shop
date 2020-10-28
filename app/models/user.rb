class User < ApplicationRecord
  has_secure_password
  validates_presence_of :name, :street_address, :city, :state, :zip, :email, :password
  validates :email, uniqueness: true, presence: true

  enum role: ['default', 'merchant', 'admin']
end
