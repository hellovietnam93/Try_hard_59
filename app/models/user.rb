class User < ApplicationRecord
   validates :name, presence: true
   validates :phone, numericality: true
   validates :ngaysinh, presence: true
   validate :check_length, :check_ngaysinh, :check_phone

   private

   def check_length
   if self.name && self.name.length < 30
   self.errors.add :name, "ten qua ngan"
   end
   end

   def check_ngaysinh
   t = Time.now
   if self.ngaysinh && (self.ngaysinh.year < t.year - 90 || self.ngaysinh.year > t.year - 7)
   self.errors.add :ngaysinh, "khong hop tuoi"
   end
   end

   def check_phone
   unless self.phone.length == 10 && self.phone[0] == 0
   self.errors.add :phone, "khong hop le"
   end
   end

end
