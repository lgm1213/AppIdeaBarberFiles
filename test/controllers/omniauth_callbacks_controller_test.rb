require "test_helper"

class OmniauthCallbacksControllerTest < ActionDispatch::IntegrationTest
  test "should get instagram" do
    get omniauth_callbacks_instagram_url
    assert_response :success
  end
end
