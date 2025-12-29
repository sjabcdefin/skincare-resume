# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @formatter = ResumeFormatter.new(user: current_user, session: session)
    @resume = current_user&.skincare_resume
    @resume_status = decide_resume_state
  end

  private

  def decide_resume_state
    return 'before_login' unless current_user
    return 'no_resume' unless @resume

    case @resume.status
    when 'draft'
      'draft_resume'
    when 'completed'
      'completed_resume'
    end
  end
end
