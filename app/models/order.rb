class Order < ApplicationRecord
  belongs_to :user
  # belongs_to :seller_product

  has_many :order_items, dependent: :destroy  

  enum :status, { preparing: 0, shipped: 1, delivered: 2, cancelled: 3, refunded: 4 }

  def status_tr
    case status
    when 'preparing'
      'Hazırlanıyor'
    when 'shipped' 
      'Kargoda'
    when 'delivered'
      'Teslim Edildi'
    when 'cancelled'
      'İptal Edildi'
    when 'refunded'
      'İade Edildi'
    else
      status.humanize
    end
  end

  def can_be_updated_by?(user)
    seller_product.user == user
  end

  def can_be_cancelled?
    preparing? || shipped?
  end
  
  def cancel!
    return false unless can_be_cancelled?
    
    update!(status: 'cancelled')
  end

end
