# frozen_string_literal: true

class SkincareResumesController < ApplicationController
  def confirmation
    @formatter = ResumeFormatter.new(user: current_user, session: session)
  end

  def update
    current_user ? update_status_for_login : update_status_for_guest
  end

  def destroy
    session.delete('resume_data')
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
    session['resume_data'] ||= {}
    session['resume_data']['status'] = params[:status]

    redirect_to '/auth/google_oauth2'
  end
end
