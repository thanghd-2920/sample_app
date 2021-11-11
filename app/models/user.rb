class User < ApplicationRecord
  before_save{self.email = email.downcase}
  validates :name, presence: true, length: {maximum: Settings.atrr.lenght_50}
  validates :email, presence: true, length: {maximum: Settings.atrr.lenght_255},
  format: {with: Settings.regex.email},
  uniqueness: true
  has_secure_password
  validates :password_digest, presence: true, length: {minimum: Settings.atrr.lenght_6}
  def downcase_email
    self.email.downcase!
  end
end
