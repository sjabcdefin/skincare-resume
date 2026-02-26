# frozen_string_literal: true

class SkincareResumesController < ApplicationController
  def confirmation
    @resume = repository.resume
    @display_resume = ResumeDisplayFormatter.new(resume: @resume)
    @print_resume = ResumePrintFormatter.new(resume: @resume)
  end

  def update
    repository.resume.update!(status_params)
    redirect_path = current_user ? root_path : '/auth/google_oauth2'

    redirect_to redirect_path, notice: '履歴書の登録を完了しました。'
  end

  def destroy
    session.delete('resume_uuid')
    redirect_to root_path
  end

  private

  def repository
    @repository ||= ResumeBasedRepository.new(
      user: current_user,
      session: session
    )
  end

  def status_params
    params.require(:skincare_resume).permit(:status)
  end
end
