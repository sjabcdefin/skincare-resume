# frozen_string_literal: true

require 'test_helper'

class ResumeResolverTest < ActiveSupport::TestCase
  test 'returns existing resume when logged in with resume' do
    alice = users(:alice)

    assert_no_difference('SkincareResume.count') do
      resume = ResumeResolver.new(user: alice, session: {}).call
      assert_equal alice.skincare_resume, resume
    end
  end

  test 'returns nil when logged in without resume' do
    bob = users(:bob)

    assert_no_difference('SkincareResume.count') do
      resume = ResumeResolver.new(user: bob, session: {}).call
      assert_nil resume
    end
  end

  test 'returns existing resume when guest with session' do
    guest_session = { 'resume_uuid' => skincare_resumes(:resume_without_user).uuid }

    assert_no_difference('SkincareResume.count') do
      resume = ResumeResolver.new(user: nil, session: guest_session).call
      assert_equal SkincareResume.find_by(uuid: guest_session['resume_uuid']), resume
    end
  end

  test 'returns existing resume when guest without session' do
    assert_no_difference('SkincareResume.count') do
      resume = ResumeResolver.new(user: nil, session: {}).call
      assert_nil resume
    end
  end
end
