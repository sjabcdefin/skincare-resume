# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @resume = current_user&.skincare_resume
    @resume_status = decide_resume_state
    @formatter = ResumeFormatter.new(user: current_user, session: session)
  end

  private

  def decide_resume_state
    return 'before_login' unless current_user
    return 'no_resume' unless @resume

    'resume_overview'
  end
end
