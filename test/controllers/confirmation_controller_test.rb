# frozen_string_literal: true

require 'test_helper'

class ConfirmationControllerTest < ActionDispatch::IntegrationTest
  test 'should get show' do
    get confirm_show_url
    assert_response :success
  end
end
