require "application_system_test_case"

class AllergiesTest < ApplicationSystemTestCase
  setup do
    @allergy = allergies(:one)
  end

  test "visiting the index" do
    visit allergies_url
    assert_selector "h1", text: "Allergies"
  end

  test "should create allergy" do
    visit allergies_url
    click_on "New allergy"

    fill_in "Name", with: @allergy.name
    click_on "Create Allergy"

    assert_text "Allergy was successfully created"
    click_on "Back"
  end

  test "should update Allergy" do
    visit allergy_url(@allergy)
    click_on "Edit this allergy", match: :first

    fill_in "Name", with: @allergy.name
    click_on "Update Allergy"

    assert_text "Allergy was successfully updated"
    click_on "Back"
  end

  test "should destroy Allergy" do
    visit allergy_url(@allergy)
    accept_confirm { click_on "Destroy this allergy", match: :first }

    assert_text "Allergy was successfully destroyed"
  end
end
