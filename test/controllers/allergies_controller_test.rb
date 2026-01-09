require "test_helper"

class AllergiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @allergy = allergies(:one)
  end

  test "should get index" do
    get allergies_url
    assert_response :success
  end

  test "should get new" do
    get new_allergy_url
    assert_response :success
  end

  test "should create allergy" do
    assert_difference("Allergy.count") do
      post allergies_url, params: { allergy: { name: @allergy.name, skincare_resume_id: @allergy.skincare_resume_id } }
    end

    assert_redirected_to allergy_url(Allergy.last)
  end

  test "should show allergy" do
    get allergy_url(@allergy)
    assert_response :success
  end

  test "should get edit" do
    get edit_allergy_url(@allergy)
    assert_response :success
  end

  test "should update allergy" do
    patch allergy_url(@allergy), params: { allergy: { name: @allergy.name, skincare_resume_id: @allergy.skincare_resume_id } }
    assert_redirected_to allergy_url(@allergy)
  end

  test "should destroy allergy" do
    assert_difference("Allergy.count", -1) do
      delete allergy_url(@allergy)
    end

    assert_redirected_to allergies_url
  end
end
