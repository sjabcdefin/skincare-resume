# frozen_string_literal: true

require 'test_helper'

class SkincareResume::ConfirmationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @alice = users(:alice)
    @session = { 'resume_uuid' => skincare_resumes(:resume_without_user).uuid }
  end

  test 'gets show when logged in with resume' do
    stub_current_user @alice do
      get skincare_resume_confirmation_path
      assert_response :success
    end
  end

  test 'gets show when logged in without resume' do
    stub_current_user @bob do
      get skincare_resume_confirmation_path
      assert_response :success
    end
  end

  test 'gets show when not logged in with resume' do
    stub_session @session do
      get skincare_resume_confirmation_path
      assert_response :success
    end
  end

  test 'gets show when not logged in without resume' do
    get skincare_resume_confirmation_path
    assert_response :success
  end
end
