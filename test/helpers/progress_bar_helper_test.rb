# frozen_string_literal: true

require 'test_helper'

class ProgressBarHelperTest < ActionView::TestCase
  include ProgressBarHelper

  test 'skincare_steps returns correct steps hash' do
    steps = skincare_steps

    assert_equal 5, steps.size
    assert_equal products_path, steps['products']
    assert_equal medications_path, steps['medications']
    assert_equal allergies_path, steps['allergies']
    assert_equal treatments_path, steps['treatments']
    assert_equal skincare_resume_confirmation_path, steps['confirmations']
  end

  test 'step_circle_class returns active class when step is current' do
    result = step_circle_class('products', 'products')

    assert_includes result, 'bg-[#5F7F67]'
    assert_includes result, 'border-[#5F7F67]'
  end

  test 'step_circle_class returns inactive class when step is not current' do
    result = step_circle_class('products', 'medications')

    assert_includes result, 'bg-white'
    assert_includes result, 'border-[#5F7F67]'
  end
end
