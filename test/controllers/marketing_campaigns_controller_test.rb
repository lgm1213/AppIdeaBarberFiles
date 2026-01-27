require "test_helper"

class MarketingCampaignsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get marketing_campaigns_new_url
    assert_response :success
  end

  test "should get create" do
    get marketing_campaigns_create_url
    assert_response :success
  end
end
