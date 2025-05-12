class SellerProduct < ApplicationRecord
  belongs_to :user
  belongs_to :product

  has_many :cart_items
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :product_id, uniqueness: { scope: :user_id, message: "Bu satıcı bu ürün için zaten eklenmiş!" }

  def seller_info
    if user
      "#{user.full_name} - Fiyat: #{price} TL, Stok: #{stock}"
    else
      "Satıcı Bilinmiyor - Fiyat: #{price} TL, Stok: #{stock}"
    end
  end
end
