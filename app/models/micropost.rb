class Micropost < ApplicationRecord
  belongs_to :user
  scope :recent, -> {order created_at: :desc}
  mount_uploader :picture, PictureUploader
  validates :user, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validate  :picture_size

  private

  def picture_size
    if picture.size > 5.megabytes
      errors.add :picture, t("error.picture")
    end
  end
end
