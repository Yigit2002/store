class User < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy
  has_many :cards, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :products, through: :comments
  has_many :addresses, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_products, through: :favorites, source: :product
  has_many :products, foreign_key: :seller_ids, dependent: :destroy

  validates :first_name, :last_name, length: { maximum: 50 }, allow_blank: true
  validates :telefon_numarasi, length: {maximum: 15}, allow_blank: true

  enum :role, { customer: 0, admin: 1, seller: 2 }, default: :customer

  has_one :cart, dependent: :destroy
  
  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
