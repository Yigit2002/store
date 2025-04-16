class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :cards, dependent: :destroy


  enum :role, { customer: 0, admin: 1 }, default: :customer

  has_many :favorites, dependent: :destroy
  has_many :favorite_products, through: :favorites, source: :product
  has_one :cart, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
