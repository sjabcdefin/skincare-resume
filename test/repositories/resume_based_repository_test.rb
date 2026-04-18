# frozen_string_literal: true

require 'test_helper'

class ResumeBasedRepositoryTest < ActiveSupport::TestCase
  test 'returns resume when logged in' do
    user = users(:alice)
    repository = ResumeBasedRepository.new(user:, session: {})

    assert_equal user.skincare_resume, repository.resume
  end

  test 'returns nil when logged in user has no resume' do
    user = users(:bob)
    repository = ResumeBasedRepository.new(user:, session: {})

    assert_nil repository.resume
  end

  test 'returns resume from session when guest' do
    resume = skincare_resumes(:resume_without_user)
    session = { 'resume_uuid' => resume.uuid }
    repository = ResumeBasedRepository.new(user: nil, session: session)

    assert_equal resume, repository.resume
  end

  test 'returns nil when guest has no resume' do
    repository = ResumeBasedRepository.new(user: nil, session: {})

    assert_nil repository.resume
  end
end
