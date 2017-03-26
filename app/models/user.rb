class User < ApplicationRecord

  before_save{self.email = email.downcase}

  validates :name, presence: true, length:{maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length:{maximum: 255},
    format:{with: VALID_EMAIL_REGEX},
    uniqueness:{case_sensitive: false}
  validates :password, presence: true, length:{minimum: 6}
  validate :valid_date

  has_secure_password

  private

  def valid_date
    errors.add :birthday, "Ngay sinh khong hop le" if birthday &&
      (birthday > Date.today - 7.years || birthday < Date.today - 90.years)
    errors.add :telephone_number, "khong hop le" if telephone_number &&
      10 != telephone_number.length && 0 == telephone_number[0]
  end
end
