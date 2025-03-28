require "test_helper"

class ProductTest < ActiveSupport::TestCase
  ActionMailer::TestHelper

  test "Stok yenilendiğinde email üzerinden bilgilendir." do
    product = products(:tshirt)

    product.update(inventory_count: 0)

    assert_emails 1 do
      product.update(inventory_count: 99)
    end
  end
end
