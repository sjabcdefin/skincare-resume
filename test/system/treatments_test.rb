# frozen_string_literal: true

require 'application_system_test_case'

class TreatmentsTest < ApplicationSystemTestCase
  setup do
    @treatment = treatments(:one)
  end

  test 'visiting the index' do
    visit treatments_url
    assert_selector 'h1', text: 'Treatments'
  end

  test 'should create treatment' do
    visit treatments_url
    click_on 'New treatment'

    fill_in 'Name', with: @treatment.name
    fill_in 'Skincare resume', with: @treatment.skincare_resume_id
    fill_in 'Treated on', with: @treatment.treated_on
    click_on 'Create Treatment'

    assert_text 'Treatment was successfully created'
    click_on 'Back'
  end

  test 'should update Treatment' do
    visit treatment_url(@treatment)
    click_on 'Edit this treatment', match: :first

    fill_in 'Name', with: @treatment.name
    fill_in 'Skincare resume', with: @treatment.skincare_resume_id
    fill_in 'Treated on', with: @treatment.treated_on
    click_on 'Update Treatment'

    assert_text 'Treatment was successfully updated'
    click_on 'Back'
  end

  test 'should destroy Treatment' do
    visit treatment_url(@treatment)
    accept_confirm { click_on 'Destroy this treatment', match: :first }

    assert_text 'Treatment was successfully destroyed'
  end
end
