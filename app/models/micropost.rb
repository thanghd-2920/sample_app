class Micropost < ApplicationRecord
  belongs_to :user
  scope :recent_posts, -> {order created_at: :desc}
  has_one_attached :image
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.atrr.lenght_140}
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
    message: I18n.t("img.invalid") },
    size: { less_than: 5.megabytes,
      message: I18n.t("img.min") }
      def display_image
        image.variant resize_to_limit: [500, 500]
      end
    end
