# frozen_string_literal: true

class SkincareResumesCleanupJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info '[SkincareResumesCleanupJob] start'

    targets = SkincareResume.where(user_id: nil).where('created_at < ?', 3.days.ago)

    target_count = targets.count
    Rails.logger.info "[SkincareResumesCleanupJob] target_count=#{target_count}"

    deleted_count = targets.destroy_all.size
    Rails.logger.info "[SkincareResumesCleanupJob] finished - deleted_count=#{deleted_count}"
  rescue StandardError => e
    Rails.logger.error "[SkincareResumesCleanupJob] error - #{e.class}: #{e.message}"

    begin
      AdminMailer.job_failed(e).deliver_now
    rescue StandardError => mail_error
      Rails.logger.error "[SkincareResumesCleanupJob] mail_error - #{mail_error.class}: #{mail_error.message}"
    end

    raise
  end
end
