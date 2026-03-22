# frozen_string_literal: true

require 'test_helper'

class SkincareResumesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @alice = users(:alice)
    @session = { 'resume_uuid' => skincare_resumes(:without_user).uuid }
  end

  test 'should get confirmation when logged in' do
    stub_current_user @alice do
      get confirmation_skincare_resume_url
      assert_response :success
    end
  end

  test 'should get confirmation when not logged in' do
    stub_session @session do
      get confirmation_skincare_resume_url
      assert_response :success
    end
  end
end
