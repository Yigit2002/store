class SellerProduct < ApplicationRecord
  belongs_to :user
  belongs_to :product

  has_many :cart_items
  has_many :orders
  has_many :subscribers, dependent: :destroy

  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :product_id, uniqueness: { scope: :user_id, message: "Bu satıcı bu ürün için zaten eklenmiş!" }

  after_update_commit :check_product_stock, if: :back_in_stock?
  
  def back_in_stock?
    stock_previously_was.zero? && stock > 0
  end

  def check_product_stock
    other_seller_products = SellerProduct.where(product: product).excluding(self)
    if other_seller_products.sum(:stock) == 0
      product.notify_subscribers
    end
  end

  def seller_info
    "#{user.full_name} - Fiyat: #{price} TL, Stok: #{stock}" 
  end
end
