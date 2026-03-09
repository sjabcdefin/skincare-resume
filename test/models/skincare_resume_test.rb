# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'destroying resume destroys products' do
    resume = skincare_resumes(:one)

    assert_difference('Product.count', -4) do
      resume.destroy!
    end
  end
end
