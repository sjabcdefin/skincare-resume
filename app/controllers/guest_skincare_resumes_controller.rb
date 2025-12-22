# frozen_string_literal: true

class GuestSkincareResumesController < ApplicationController
  def save
    session['resume_data'] ||= {}
    session['resume_data']['status'] = params[:status]

    redirect_to '/auth/google_oauth2'
  end
end
