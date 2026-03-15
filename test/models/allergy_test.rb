# frozen_string_literal: true

require 'test_helper'

class AllergyTest < ActiveSupport::TestCase
  setup do
    @resume = skincare_resumes(:with_user)
  end

  test 'should not save allergy without name' do
    allergy = @resume.allergies.new
    assert_not allergy.save
  end

  test 'should save allergy with name' do
    allergy = @resume.allergies.new(name: '金属(酸化亜鉛)')
    assert allergy.save
  end

  test 'order_for_display sorts correctly' do
    allergy1 = allergies(:metal_zinc)
    allergy2 = allergies(:metal_silver)
    allergy3 = allergies(:cedar_pollen)
    result = @resume.allergies.order_for_display.to_a

    assert_equal [allergy1, allergy2, allergy3], result
  end

  test 'order_for_print sorts correctly' do
    allergy1 = allergies(:metal_zinc)
    allergy2 = allergies(:metal_silver)
    allergy3 = allergies(:cedar_pollen)
    result = @resume.allergies.order_for_print.to_a

    assert_equal [allergy3, allergy2, allergy1], result
  end

  test 'display_date returns nil' do
    allergy = allergies(:metal_zinc)

    assert_nil allergy.display_date
  end
end
