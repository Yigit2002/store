class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :seller, class_name: 'User', optional: true
  belongs_to :seller_product
  belongs_to :order, optional: true

  validates :quantity, numericality: { greater_than_or_equal_to: 1 }

  def total_price
    seller_product&.price.to_f * quantity.to_f
  end
end
