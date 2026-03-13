# frozen_string_literal: true

require 'test_helper'

class SkincareResumesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @alice = users(:alice)
    @session = { 'resume_uuid' => skincare_resumes(:two).uuid }
  end

  test 'should get confirmation when logged in' do
    sign_in @alice do
      get confirmation_skincare_resume_url
      assert_response :success
    end
  end

  test 'should get confirmation when not logged in' do
    with_session @session do
      get confirmation_skincare_resume_url
      assert_response :success
    end
  end
end
