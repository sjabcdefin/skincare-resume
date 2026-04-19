# frozen_string_literal: true

require 'test_helper'

class ResumeResolverTest < ActiveSupport::TestCase
  test 'returns existing resume when logged in' do
    alice = users(:alice)

    assert_no_difference('SkincareResume.count') do
      resume = ResumeResolver.new(user: alice, session: {}).call
      assert_equal alice.skincare_resume, resume
    end
  end

  test 'returns existing resume when guest' do
    guest_session = { 'resume_uuid' => skincare_resumes(:resume_without_user).uuid }

    assert_no_difference('SkincareResume.count') do
      resume = ResumeResolver.new(user: nil, session: guest_session).call
      assert_equal SkincareResume.find_by(uuid: guest_session['resume_uuid']), resume
    end
  end
end
