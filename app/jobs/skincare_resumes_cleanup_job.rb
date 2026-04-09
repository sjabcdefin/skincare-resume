# frozen_string_literal: true

class SkincareResumesCleanupJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info '[SkincareResumesCleanupJob] start'

    targets = SkincareResume.where(user_id: nil)

    target_count = targets.count
    Rails.logger.info "[SkincareResumesCleanupJob] target_count=#{target_count}"

    deleted_count = targets.destroy_all.size
    Rails.logger.info "[SkincareResumesCleanupJob] finished - deleted_count=#{deleted_count}"
  end
end
