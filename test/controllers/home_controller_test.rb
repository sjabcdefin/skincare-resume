# frozen_string_literal: true

require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test 'should get root when logged in with resume' do
    sign_in users(:alice) do
      get root_url
      assert_response :success
    end
  end

  test 'should get root when logged in without resume' do
    sign_in users(:bob) do
      get root_url
      assert_response :success
    end
  end

  test 'should get root when not logged in' do
    get root_url
    assert_response :success
  end
end
