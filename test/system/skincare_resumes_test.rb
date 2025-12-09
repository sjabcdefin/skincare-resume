require "application_system_test_case"

class SkincareResumesTest < ApplicationSystemTestCase
  setup do
    @skincare_resume = skincare_resumes(:one)
  end

  test "visiting the index" do
    visit skincare_resumes_url
    assert_selector "h1", text: "Skincare resumes"
  end

  test "should create skincare resume" do
    visit skincare_resumes_url
    click_on "New skincare resume"

    fill_in "Status", with: @skincare_resume.status
    fill_in "User", with: @skincare_resume.user_id
    click_on "Create Skincare resume"

    assert_text "Skincare resume was successfully created"
    click_on "Back"
  end

  test "should update Skincare resume" do
    visit skincare_resume_url(@skincare_resume)
    click_on "Edit this skincare resume", match: :first

    fill_in "Status", with: @skincare_resume.status
    fill_in "User", with: @skincare_resume.user_id
    click_on "Update Skincare resume"

    assert_text "Skincare resume was successfully updated"
    click_on "Back"
  end

  test "should destroy Skincare resume" do
    visit skincare_resume_url(@skincare_resume)
    accept_confirm { click_on "Destroy this skincare resume", match: :first }

    assert_text "Skincare resume was successfully destroyed"
  end
end
