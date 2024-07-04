require "test_helper"

class EmergencyNumbersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get emergency_numbers_index_url
    assert_response :success
  end

  test "should get show" do
    get emergency_numbers_show_url
    assert_response :success
  end
end
