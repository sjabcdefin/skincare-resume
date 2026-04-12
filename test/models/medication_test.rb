# frozen_string_literal: true

require 'test_helper'

class MedicationTest < ActiveSupport::TestCase
  setup do
    @resume = skincare_resumes(:resume_with_user)
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
    medication1 = medications(:bepio_gel)
    medication2 = medications(:hirudoid_lotion)
    medication3 = medications(:vitamin_c_pill)
    medication4 = medications(:vitamin_d_pill)
    result = @resume.medications.order_for_display.to_a

    assert_equal [medication2, medication4, medication3, medication1], result
  end

  test 'order_for_print sorts correctly' do
    medication1 = medications(:bepio_gel)
    medication2 = medications(:hirudoid_lotion)
    medication3 = medications(:vitamin_c_pill)
    medication4 = medications(:vitamin_d_pill)
    result = @resume.medications.order_for_print.to_a

    assert_equal [medication1, medication3, medication4, medication2], result
  end

  test 'display_date returns started_on' do
    medication = medications(:bepio_gel)

    assert_equal Date.new(2025, 12, 25), medication.display_date
  end
end
