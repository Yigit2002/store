class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :id, uniqueness: { scope: :product_id, message: "Bu ürün zaten favorilerinizde!" }
end
