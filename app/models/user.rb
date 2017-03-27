class User < ApplicationRecord
   validates :name, presence: true
   validates :phone, numericality: true
   validates :birthday, presence: true
   validate :check_length, :check_birthday, :check_phone

   private

   def check_length
     if name && name.length < 30
     errors.add :name, "ten qua ngan"
     end
   end

   def check_birthday
   t = Time.now
     if birthday && ((birthday.year < t.year - 90) || (birthday.year > t.year - 7))
     errors.add :birthday, "khong hop tuoi"
     end
   end

   def check_phone
     unless phone.length == 10 && phone[0] == 0
     errors.add :phone, "khong hop le"
     end
   end

  has_secure_password
    validates :password, presence: true, length: { minimum: 6 }

  end
