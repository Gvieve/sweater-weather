class User < ApplicationRecord
  has_secure_password

  validates :email, uniqueness: true, on: :create, presence: true
  validates :email, format: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create

  before_create :set_api_key

  def set_api_key
    self.api_key = generate_api_key
  end

  def generate_api_key
    SecureRandom.hex(14)
  end
end
