# frozen_string_literal: true

class SkincareResume::ConfirmationsController < ApplicationController
  before_action :set_resume

  def show
    @display_resume = ResumeFormatter.new(resume: @resume, mode: :display)
    @print_resume = ResumeFormatter.new(resume: @resume, mode: :print)
  end

  private

  def set_resume
    @resume = ResumeResolver.new(user: current_user, session: session).call
  end
end
