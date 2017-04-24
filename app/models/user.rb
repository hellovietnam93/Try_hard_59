class User < ApplicationRecord
  attr_accessor :remember_token

  before_save {email.downcase!}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 255},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length: {maximum: 10}, allow_nil: true
  validate :check_phone_number
  validate :check_birthday, if: :is_valid_birthday?

  def remember
    self.remember_token = User.new_token
    update_attributes remember_digest: User.digest(remember_token)
  end

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attributes remember_digest: nil
  end

  def is_user? user
    user == self
  end

  private

  def check_birthday
    errors.add :birthday, "Birthday have to be between 7 and 90 years before"
  end

  def is_valid_birthday?
    birthday &&
      (Time.now.year - birthday.year < 7 || Time.now.year - birthday.year > 90)
  end

  def check_phone_number
    if phone_number
      if !phone_number[0].eql? '0'
        errors.add :phone_number, "Phone number have to begin with 0"
      elsif phone_number.length != 10
        errors.add :phone_number, "Phone number have to have 10 digits"
      end
    end
  end

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end
end
