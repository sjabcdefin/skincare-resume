# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    user = find_or_create_from_auth_hash(auth_hash)
    log_in(user)
    after_save_for_guest(user)
    redirect_to root_path
  end

  def destroy
    log_out
    redirect_to root_path
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end

  def find_or_create_from_auth_hash(auth_hash)
    name = auth_hash['info']['name']
    email = auth_hash['info']['email']
    user = User.find_or_create_by(email:)
    user.update!(name:)
    user
  end

  def after_save_for_guest(user)
    return unless session['resume_uuid']
    return unless request.env.dig('omniauth.params', 'button') == 'save'

    user.skincare_resume&.destroy!
    SkincareResume.find_by!(uuid: session['resume_uuid']).update!(user:)
    session.delete('resume_uuid')
  end
end
