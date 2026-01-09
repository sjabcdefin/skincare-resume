require "test_helper"

class SkincareResumesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @skincare_resume = skincare_resumes(:one)
  end

  test "should get index" do
    get skincare_resumes_url
    assert_response :success
  end

  test "should get new" do
    get new_skincare_resume_url
    assert_response :success
  end

  test "should create skincare_resume" do
    assert_difference("SkincareResume.count") do
      post skincare_resumes_url, params: { skincare_resume: { status: @skincare_resume.status, user_id: @skincare_resume.user_id, uuid: @skincare_resume.uuid } }
    end

    assert_redirected_to skincare_resume_url(SkincareResume.last)
  end

  test "should show skincare_resume" do
    get skincare_resume_url(@skincare_resume)
    assert_response :success
  end

  test "should get edit" do
    get edit_skincare_resume_url(@skincare_resume)
    assert_response :success
  end

  test "should update skincare_resume" do
    patch skincare_resume_url(@skincare_resume), params: { skincare_resume: { status: @skincare_resume.status, user_id: @skincare_resume.user_id, uuid: @skincare_resume.uuid } }
    assert_redirected_to skincare_resume_url(@skincare_resume)
  end

  test "should destroy skincare_resume" do
    assert_difference("SkincareResume.count", -1) do
      delete skincare_resume_url(@skincare_resume)
    end

    assert_redirected_to skincare_resumes_url
  end
end
