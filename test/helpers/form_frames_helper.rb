# frozen_string_literal: true

require 'test_helper'

class FormFramesHelperTest < ActionView::TestCase
  include FormFramesHelper

  test 'form_frame_for(resource) returns dom_id' do
    product = products(:zoskin_cleanser)
    result = form_frame_for(product)
    assert_equal result, dom_id(product)
  end

  test 'form_frame_for(resource) returns new_form' do
    result = form_frame_for(Product.none)
    assert_equal result, 'new_form'
  end
end
