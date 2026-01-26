# frozen_string_literal: true

class SkincareResumesCleanupJob < ApplicationJob
  queue_as :default

  def perform
    SkincareResume.where(user_id: nil).destroy_all
  end
end
