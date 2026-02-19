# frozen_string_literal: true

class SkincareResumesController < ApplicationController
  def confirmation
    @formatter = ResumeFormatter.new(user: current_user, session: session)
  end

  def create
    @resume = repository.build
    @resume.save!
    session['resume_uuid'] = @resume.uuid unless current_user

    redirect_to products_path
  end

  def update
    @resume = repository.resume
    redirect_path = current_user ? root_path : '/auth/google_oauth2'

    if @resume.update(status: params[:status])
      redirect_to redirect_path, notice: '履歴書の登録を完了しました。'
    else
      render :confirmation, status: :unprocessable_entity
    end
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
end
