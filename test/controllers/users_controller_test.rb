# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'should destroy account' do
    stub_current_user users(:alice) do
      assert_difference('User.count', -1) do
        delete account_url
      end
      assert_redirected_to root_url
    end
  end
end
