# frozen_string_literal: true

class Maintenance::CleanupController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    SkincareResume.where(user_id: nil).destroy_all
    head :ok
  end
end
