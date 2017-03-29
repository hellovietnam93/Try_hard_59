class User < ApplicationRecord
  attr_accessor :remember_token

  before_save{self.email = email.downcase}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 255},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validate :valid_date
  validates :password, presence: true, length: {minimum: 6}, allow_blank: true

  has_secure_password

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

  def is_user? user
    self == user
  end

  def remember
    self.remember_token = User.new_token
    update_attributes remember_digest: User.digest(remember_token)
  end

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attribute :remember_digest, nil
  end

  private

  def valid_date
    errors.add :birthday, "Ngay sinh khong hop le" if birthday &&
      (birthday > Date.today - 7.years || birthday < Date.today - 90.years)
    errors.add :telephone_number, "khong hop le" if telephone_number &&
      10 != telephone_number.length && 0 == telephone_number[0]
  end
end
