require "test_helper"

class ProductTest < ActiveSupport::TestCase
  ActionMailer::TestHelper

  test "Stok yenilendiğinde email üzerinden bilgilendir." do
    product = products(:tshirt)

    product.update(stock: 0)

    assert_emails 1 do
      product.update(stock: 99)
    end
  end
end
