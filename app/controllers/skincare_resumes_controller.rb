# frozen_string_literal: true

class SkincareResumesController < ApplicationController
  def confirmation
    @formatter = ResumeFormatter.new(user: current_user, session: session)
  end

  def update
    current_user ? update_status_for_login : update_status_for_guest
  end

  def destroy
    session.delete('resume_uuid')
    redirect_to root_path
  end

  private

  def update_status_for_login
    @resume = current_user.skincare_resume

    if @resume.update(status: params[:status])
      redirect_to root_path, notice: t('.success')
    else
      render '/skincare_resume/confirmation', status: :unprocessable_entity
    end
  end

  def update_status_for_guest
    @resume = SkincareResume.find_by(uuid: session['resume_uuid'])

    if @resume.update(status: params[:status])
      redirect_to '/auth/google_oauth2'
    else
      render '/skincare_resume/confirmation', status: :unprocessable_entity
    end
  end
end
