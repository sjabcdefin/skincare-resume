# frozen_string_literal: true

require 'test_helper'

class TreatmentTest < ActiveSupport::TestCase
  setup do
    @resume = skincare_resumes(:one)
  end

  test 'should not save treatment without name' do
    treatment = @resume.treatments.new
    assert_not treatment.save
  end

  test 'should save treatment with name' do
    treatment = @resume.treatments.new(name: 'エレクトロポーション ケアシス')
    assert treatment.save
  end

  test 'order_for_display sorts correctly' do
    treatment1 = treatments(:one)
    treatment2 = treatments(:two)
    treatment3 = treatments(:three)
    treatment4 = treatments(:four)
    result = @resume.treatments.order_for_display.to_a

    assert_equal [treatment2, treatment4, treatment3, treatment1], result
  end

  test 'order_for_print sorts correctly' do
    treatment1 = treatments(:one)
    treatment2 = treatments(:two)
    treatment3 = treatments(:three)
    treatment4 = treatments(:four)
    result = @resume.treatments.order_for_print.to_a

    assert_equal [treatment1, treatment3, treatment4, treatment2], result
  end

  test 'display_date returns started_on' do
    treatment = treatments(:one)

    assert_equal Date.new(2025, 12, 25), treatment.display_date
  end
end
