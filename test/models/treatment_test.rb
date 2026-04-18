# frozen_string_literal: true

require 'test_helper'

class TreatmentTest < ActiveSupport::TestCase
  setup do
    @resume = skincare_resumes(:resume_with_user)
  end

  test 'should not save treatment without name' do
    treatment = @resume.treatments.new
    assert_not treatment.save
  end

  test 'should not save treatment with blank name' do
    treatment = @resume.treatments.new(name: '')
    assert_not treatment.save
  end

  test 'should save treatment with name' do
    treatment = @resume.treatments.new(name: 'エレクトロポーション ケアシス')
    assert treatment.save
  end

  test 'order_for_display sorts by treated_on asc with nulls first' do
    result = @resume.treatments.order_for_display.to_a

    assert_nil result.first.treated_on
  end

  test 'order_for_display sorts by id when treated_on is same' do
    milano_repeel = treatments(:milano_repeel)
    lumecca = treatments(:lumecca)
    result = @resume.treatments.order_for_display.to_a

    assert_equal([milano_repeel, lumecca], result.select { |p| p.treated_on.nil? })
  end

  test 'order_for_display sorts correctly' do
    caresys_recent = treatments(:caresys_recent)
    milano_repeel = treatments(:milano_repeel)
    caresys_old = treatments(:caresys_old)
    lumecca = treatments(:lumecca)
    result = @resume.treatments.order_for_display.to_a

    assert_equal [milano_repeel, lumecca, caresys_old, caresys_recent], result
  end

  test 'order_for_print sorts by treated_on desc with nulls last' do
    result = @resume.treatments.order_for_print.to_a

    assert_nil result.last.treated_on
  end

  test 'order_for_print sorts by id when treated_on is same' do
    milano_repeel = treatments(:milano_repeel)
    lumecca = treatments(:lumecca)
    result = @resume.treatments.order_for_print.to_a

    assert_equal([lumecca, milano_repeel], result.select { |p| p.treated_on.nil? })
  end

  test 'order_for_print sorts correctly' do
    caresys_recent = treatments(:caresys_recent)
    milano_repeel = treatments(:milano_repeel)
    caresys_old = treatments(:caresys_old)
    lumecca = treatments(:lumecca)
    result = @resume.treatments.order_for_print.to_a

    assert_equal [caresys_recent, caresys_old, lumecca, milano_repeel], result
  end

  test 'display_date returns treated_on when present' do
    treatment = treatments(:caresys_recent)

    assert_equal Date.new(2025, 12, 25), treatment.display_date
  end

  test 'display_date returns nil when treated_on is nil' do
    treatment = treatments(:milano_repeel)

    assert_nil treatment.display_date
  end
end
