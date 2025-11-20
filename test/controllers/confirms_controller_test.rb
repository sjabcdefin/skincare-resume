# frozen_string_literal: true

require 'test_helper'

class ConfirmsControllerTest < ActionDispatch::IntegrationTest
  test 'should get show' do
    get confirms_show_url
    assert_response :success
  end
end
