# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @resume = current_user&.skincare_resume
    @resume_status = decide_resume_state
    @display_resume = ResumeDisplayFormatter.new(resume: @resume)
    @print_resume = ResumePrintFormatter.new(resume: @resume)
  end

  private

  def decide_resume_state
    return 'before_login' unless current_user
    return 'no_resume' unless @resume

    'resume_overview'
  end
end
