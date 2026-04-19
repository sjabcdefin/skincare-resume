# frozen_string_literal: true

class SkincareResume::ConfirmationsController < ApplicationController
  def show
    @resume = repository.resume
    @display_resume = ResumeFormatter.new(resume: @resume, mode: :display)
    @print_resume = ResumeFormatter.new(resume: @resume, mode: :print)
  end

  private

  def repository
    @repository ||= ResumeBasedRepository.new(
      user: current_user,
      session: session
    )
  end
end
