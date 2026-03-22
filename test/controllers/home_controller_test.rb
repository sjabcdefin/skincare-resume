# frozen_string_literal: true

require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test 'should get root when logged in with resume' do
    stub_current_user users(:alice) do
      get root_url
      assert_response :success
    end
  end

  test 'should get root when logged in without resume' do
    stub_current_user users(:bob) do
      get root_url
      assert_response :success
    end
  end

  test 'should get root when not logged in' do
    get root_url
    assert_response :success
  end
end
