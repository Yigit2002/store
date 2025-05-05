class Seller < ApplicationRecord
  has_many :sessions, as: :sessionable , dependent: :destroy
  has_many :seller_products
  has_many :product, through: :seller_products

  validates :name, presence: true
  validates :email_address, presence: true
end
