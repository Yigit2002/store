class Product < ApplicationRecord
  include Product::Notifications
  has_many :subscribers, dependent: :destroy

  has_many :favorites, dependent: :destroy
  has_many :favorited_by_users, through: :favorites, source: :user

  has_many :comments, dependent: :destroy
  has_many :users, through: :comments

  has_many :cart_items
  has_many :carts, through: :cart_items
  
  has_many :seller_products
  has_many :sellers, through: :seller_products, source: :user

  has_one_attached :featured_image  
  has_rich_text :description
  belongs_to :category
  
  
  validates :name, presence: true
  validates :category_id, presence: true
  # validates :seller_id, presence: true

  after_update_commit :notify_subscribers, if: :back_in_stock?

  def back_in_stock?
    inventory_count_previously_was.zero? && inventory_count > 0
  end

  def notify_subscribers
    subscribers.each do |subscriber|
      ProductMailer.with(product: self, subscriber: subscriber).in_stock.deliver_now
    end
  end
end
