require "test_helper"

class SkincareResume::ConfirmationsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get skincare_resume_confirmations_show_url
    assert_response :success
  end
end
