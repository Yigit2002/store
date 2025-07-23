class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :seller_product
end
