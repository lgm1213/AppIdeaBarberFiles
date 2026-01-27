require "test_helper"

class ChairsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get chairs_index_url
    assert_response :success
  end

  test "should get new" do
    get chairs_new_url
    assert_response :success
  end

  test "should get create" do
    get chairs_create_url
    assert_response :success
  end
end
