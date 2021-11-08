class User < ApplicationRecord
  before_save{self.email = email.downcase}
  validates :name, presence: true, length: {maximum: Settings.atrr.lenght_50}
  validates :email, presence: true, length: {maximum: Settings.atrr.lenght_255},
  format: {with: Settings.regex.email},
  uniqueness: true
  validates :password, presence: true, length: {minimum: Settings.atrr.lenght_6}
  has_secure_password

  def downcase_email
    self.email.downcase!
  end
  def User.digest string
    cost = if ActiveModel::SecurePassword.min_cost
      BCrypt::Engine::MIN_COST
    else
      BCrypt::Engine.cost
    end
    BCrypt::Password.create string, cost: cost
  end
end
