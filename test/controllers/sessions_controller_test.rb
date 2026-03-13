# frozen_string_literal: true

require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @alice = users(:alice)
    @resume = skincare_resumes(:two)
  end

  test 'creates user on first login' do
    carol = User.new(name: 'Carol', email: 'carol@gmail.com')

    assert_difference 'User.count', 1 do
      login_with_google carol
    end

    assert_redirected_to root_url
  end

  test 'does not create user on subsequent login' do
    assert_no_difference 'User.count' do
      login_with_google @alice
    end

    assert_redirected_to root_url
  end

  test 'assigns resume to user when save button clicked on first login' do
    carol = User.new(name: 'Carol', email: 'carol@gmail.com')
    with_session('resume_uuid' => @resume.uuid) do
      assert_no_difference 'SkincareResume.count' do
        login_with_google carol, save: true
      end
    end

    assert_redirected_to root_url
    user = User.find_by!(email: carol.email)
    assert_equal user, @resume.reload.user
  end

  test 'assigns resume to user when save button clicked on subsequent login' do
    with_session('resume_uuid' => @resume.uuid) do
      assert_difference 'SkincareResume.count', -1 do
        login_with_google @alice, save: true
      end
    end

    assert_redirected_to root_url
    assert_equal @alice, @resume.reload.user
  end

  test 'logs out' do
    with_session(user_id: @alice.id) do
      post logout_url
      assert_redirected_to root_url
    end
  end
end
