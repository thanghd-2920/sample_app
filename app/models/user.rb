class User < ApplicationRecord
  attr_accessor :remember_token
  before_save{self.email = email.downcase}
  validates :name, presence: true, length: {maximum: Settings.atrr.lenght_50}
  validates :email, presence: true, length: {maximum: Settings.atrr.lenght_255},
  format: {with: Settings.regex.email},
  uniqueness: true
  has_secure_password
  validates :password_digest, presence: true, length: {minimum: Settings.atrr.lenght_6}, allow_nil: true
  def downcase_email
    self.email = email.downcase
  end
  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
      BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end
end
