# frozen_string_literal: true

require 'test_helper'

class SkincareResumesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @alice = users(:alice)
    @session = { 'resume_uuid' => skincare_resumes(:resume_without_user).uuid }
  end

  test 'gets confirmation when logged in with resume' do
    stub_current_user @alice do
      get confirmation_skincare_resume_url
      assert_response :success
    end
  end

  test 'gets confirmation when logged in without resume' do
    stub_current_user @bob do
      get confirmation_skincare_resume_url
      assert_response :success
    end
  end

  test 'gets confirmation when not logged in with resume' do
    stub_session @session do
      get confirmation_skincare_resume_url
      assert_response :success
    end
  end

  test 'gets confirmation when not logged in without resume' do
    get confirmation_skincare_resume_url
    assert_response :success
  end
end
