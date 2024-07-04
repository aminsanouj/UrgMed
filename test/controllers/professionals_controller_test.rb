require "test_helper"

class ProfessionalsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get professionals_index_url
    assert_response :success
  end

  test "should get show" do
    get professionals_show_url
    assert_response :success
  end
end
