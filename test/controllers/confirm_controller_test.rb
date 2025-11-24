# frozen_string_literal: true

require 'test_helper'

class ConfirmControllerTest < ActionDispatch::IntegrationTest
  test 'should get show' do
    get confirm_show_url
    assert_response :success
  end
end
