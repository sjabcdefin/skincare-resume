# frozen_string_literal: true

require 'test_helper'

class SkincareResumesCleanupJobTest < ActiveJob::TestCase
  test 'deletes resumes older than 3 days without user' do
    old_guest_resume = SkincareResume.create!(uuid: SecureRandom.uuid, created_at: 4.days.ago)
    recent_guest_resume = SkincareResume.create!(uuid: SecureRandom.uuid, created_at: 1.day.ago)
    user_resume = skincare_resumes(:resume_with_user)

    assert_difference('SkincareResume.count', -1) do
      SkincareResumesCleanupJob.perform_now
    end

    assert_not SkincareResume.exists?(old_guest_resume.id)
    assert SkincareResume.exists?(recent_guest_resume.id)
    assert SkincareResume.exists?(user_resume.id)
  end

  test 'does nothing when no targets exist' do
    recent_guest_resume = SkincareResume.create!(uuid: SecureRandom.uuid, created_at: 1.day.ago)
    user_resume = SkincareResume.create!(uuid: SecureRandom.uuid, user: users(:alice), created_at: 4.days.ago)

    assert_no_difference('SkincareResume.count') do
      SkincareResumesCleanupJob.perform_now
    end

    assert SkincareResume.exists?(recent_guest_resume.id)
    assert SkincareResume.exists?(user_resume.id)
  end

  test 'calls AdminMailer when cleanup job raises error' do
    error = StandardError.new('test error')

    mail_mock = Minitest::Mock.new
    mail_mock.expect(:deliver_now, true)

    SkincareResume.stub :where, ->(*) { raise error } do
      AdminMailer.stub :job_failed, mail_mock do
        raised = assert_raises(StandardError) do
          SkincareResumesCleanupJob.perform_now
        end

        assert_equal error, raised
      end
    end

    mail_mock.verify
  end

  test 'logs error when mail delivery fails' do
    error = StandardError.new('test error')
    mail_error = StandardError.new('mail error')

    mailer = Object.new
    mailer.define_singleton_method(:deliver_now) { raise mail_error }

    logs = []

    Rails.logger.stub :error, ->(msg) { logs << msg } do
      SkincareResume.stub :where, ->(*) { raise error } do
        AdminMailer.stub :job_failed, ->(*) { mailer } do
          raised = assert_raises(StandardError) do
            SkincareResumesCleanupJob.perform_now
          end

          assert_equal error, raised
        end
      end
    end

    assert(logs.any? { |msg| msg.include?('mail_error') })
  end
end
