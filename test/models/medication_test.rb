# frozen_string_literal: true

require 'test_helper'

class MedicationTest < ActiveSupport::TestCase
  setup do
    @resume = skincare_resumes(:one)
  end

  test 'should not save medication without name' do
    medication = @resume.medications.new
    assert_not medication.save
  end

  test 'should save medication with name' do
    medication = @resume.medications.new(name: 'ベピオゲル')
    assert medication.save
  end

  test 'order_for_display sorts correctly' do
    medication1 = medications(:one)
    medication2 = medications(:two)
    medication3 = medications(:three)
    medication4 = medications(:four)
    result = @resume.medications.order_for_display.to_a

    assert_equal [medication2, medication4, medication3, medication1], result
  end

  test 'order_for_print sorts correctly' do
    medication1 = medications(:one)
    medication2 = medications(:two)
    medication3 = medications(:three)
    medication4 = medications(:four)
    result = @resume.medications.order_for_print.to_a

    assert_equal [medication1, medication3, medication4, medication2], result
  end

  test 'display_date returns started_on' do
    medication = medications(:one)

    assert_equal Date.new(2025, 12, 25), medication.display_date
  end
end
