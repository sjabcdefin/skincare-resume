# frozen_string_literal: true

require 'test_helper'

class ButtonHelperTest < ActionView::TestCase
  include ButtonHelper

  test 'save_button_class(true) returns cursor-not-allowed' do
    result = save_button_class(true)
    assert_includes result, 'cursor-not-allowed'
  end

  test 'save_button_class(false) returns cursor-pointer' do
    result = save_button_class(false)
    assert_includes result, 'cursor-pointer'
  end
end
