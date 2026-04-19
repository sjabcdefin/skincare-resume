# frozen_string_literal: true

require 'test_helper'

class MedicationTest < ActiveSupport::TestCase
  setup do
    @resume = skincare_resumes(:resume_with_user)
  end

  test 'should save medication with name' do
    medication = @resume.medications.new(name: 'ベピオゲル')
    assert medication.save
  end

  test 'order_for_display sorts by started_on asc with nulls first' do
    result = @resume.medications.order_for_display.to_a

    assert_nil result.first.started_on
  end

  test 'order_for_display sorts by id when started_on is same' do
    hirudoid = medications(:hirudoid_lotion)
    vitamin_d = medications(:vitamin_d_pill)
    result = @resume.medications.order_for_display.to_a

    assert_equal([hirudoid, vitamin_d], result.select { |p| p.started_on.nil? })
  end

  test 'order_for_display sorts correctly' do
    bepio_gel = medications(:bepio_gel)
    hirudoid = medications(:hirudoid_lotion)
    vitamin_c = medications(:vitamin_c_pill)
    vitamin_d = medications(:vitamin_d_pill)
    result = @resume.medications.order_for_display.to_a

    assert_equal [hirudoid, vitamin_d, vitamin_c, bepio_gel], result
  end

  test 'order_for_print sorts by started_on asc with nulls last' do
    result = @resume.medications.order_for_print.to_a

    assert_nil result.last.started_on
  end

  test 'order_for_print sorts by id when started_on is same' do
    hirudoid = medications(:hirudoid_lotion)
    vitamin_d = medications(:vitamin_d_pill)
    result = @resume.medications.order_for_print.to_a

    assert_equal([vitamin_d, hirudoid], result.select { |p| p.started_on.nil? })
  end

  test 'order_for_print sorts correctly' do
    bepio_gel = medications(:bepio_gel)
    hirudoid = medications(:hirudoid_lotion)
    vitamin_c = medications(:vitamin_c_pill)
    vitamin_d = medications(:vitamin_d_pill)
    result = @resume.medications.order_for_print.to_a

    assert_equal [bepio_gel, vitamin_c, vitamin_d, hirudoid], result
  end

  test 'display_date returns started_on when present' do
    medication = medications(:bepio_gel)

    assert_equal Date.new(2025, 12, 25), medication.display_date
  end

  test 'display_date returns nil when started_on is nil' do
    medication = medications(:hirudoid_lotion)

    assert_nil medication.display_date
  end
end
