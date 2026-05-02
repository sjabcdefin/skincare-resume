# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def build_resume
    if current_user
      current_user.skincare_resume || current_user.create_skincare_resume!
    else
      SkincareResume.create!(uuid: SecureRandom.uuid).tap do |r|
        session['resume_uuid'] = r.uuid
      end
    end
  end
end
