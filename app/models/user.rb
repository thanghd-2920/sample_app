class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest
  validates :name, presence: true, length: {maximum: Settings.atrr.lenght_50}
  validates :email, presence: true, length: {maximum: Settings.atrr.lenght_255},
  format: {with: Settings.regex.email},
  uniqueness: true
  has_secure_password
  validates :password_digest, presence: true, length: {minimum: Settings.atrr.lenght_6}, allow_nil: true
  def downcase_email
    self.email.downcase!
  end
  class << self
    def digest(string)
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
  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password? token
  end
  # def authenticated?(remember_token)
  #   BCrypt::Password.new(remember_digest).is_password?(remember_token)
  # end
  def forget
    update_attribute(:remember_digest, nil)
  end
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end
# Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now
  end
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
end
