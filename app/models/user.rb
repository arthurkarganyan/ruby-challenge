class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true
  validates :password_digest, presence: true
  validates :role, presence: true, inclusion: {in: %w(moviegoer cinema_owner)}

  def cinema_owner?
    role == "cinema_owner"
  end
end
