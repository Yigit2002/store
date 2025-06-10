class Product < ApplicationRecord
  has_many :subscribers, dependent: :destroy

  has_many :favorites, dependent: :destroy
  has_many :favorited_by_users, through: :favorites, source: :user

  has_many :comments, dependent: :destroy

  has_many :cart_items  
  has_many :carts, through: :cart_items
  
  has_many :seller_products, dependent: :destroy
  has_many :sellers, through: :seller_products, source: :user

  belongs_to :category

  has_one_attached :featured_image  
  has_rich_text :description
  
  validates :name, presence: true
  validates :category_id, presence: true

  def back_in_stock?
    seller_products.sum(:stock) > 0 && seller_products.all? { |sp| !sp.stock_previously_was.zero? }
  end

  def notify_subscribers 
    subscribers.each do |subscriber|
      ProductMailer.with(product: self, subscriber: subscriber).in_stock.deliver_now
    end
  end
end
