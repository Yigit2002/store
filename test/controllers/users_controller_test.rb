require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get users_index_url
    assert_response :success
  end

  test "should get update_balance" do
    get users_update_balance_url
    assert_response :success
  end
end
