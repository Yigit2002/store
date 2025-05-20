module Product::Notifications
  extend ActiveSupport::Concern

  included do
    has_many :subscribers, dependent: :destroy
    after_update_commit :notify_subscribers, if: :back_in_stock?
  end

  def back_in_stock?
    stock_previously_was == 0 && stock_count > 0
  end

  def notify_subscribers
    subscribers.each do |subscribers|
      ProductMailer.with(product.self, subscriber: subscriber).in_stock.deliver_later
    end
  end
end
