# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'destroying user destroys skincare_resume' do
    user = users(:alice)

    assert_difference('SkincareResume.count', -1) do
      user.destroy!
    end
  end
end
