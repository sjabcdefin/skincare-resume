# frozen_string_literal: true

require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @alice = users(:alice)
    @resume = skincare_resumes(:resume_without_user)
  end

  test 'creates user on first login' do
    david = User.new(name: 'David', email: 'david@gmail.com')

    assert_difference 'User.count', 1 do
      mock_google_auth david
      post '/auth/google_oauth2'
      follow_redirect!
    end

    assert_redirected_to root_url
  end

  test 'does not create user on subsequent login' do
    assert_no_difference 'User.count' do
      mock_google_auth @alice
      post '/auth/google_oauth2'
      follow_redirect!
    end

    assert_redirected_to root_url
  end

  test 'assigns resume to user when save button clicked on first login' do
    david = User.new(name: 'David', email: 'david@gmail.com')
    stub_session('resume_uuid' => @resume.uuid) do
      assert_no_difference 'SkincareResume.count' do
        mock_google_auth david
        post '/auth/google_oauth2?button=save'
        follow_redirect!
      end
    end

    assert_redirected_to root_url
    user = User.find_by!(email: david.email)
    assert_equal user, @resume.reload.user
  end

  test 'assigns resume to user when save button clicked on subsequent login' do
    stub_session('resume_uuid' => @resume.uuid) do
      assert_difference 'SkincareResume.count', -1 do
        mock_google_auth @alice
        post '/auth/google_oauth2?button=save'
        follow_redirect!
      end
    end

    assert_redirected_to root_url
    assert_equal @alice, @resume.reload.user
  end

  test 'logs out' do
    stub_session(user_id: @alice.id) do
      post logout_url
      assert_redirected_to root_url
    end
  end
end
