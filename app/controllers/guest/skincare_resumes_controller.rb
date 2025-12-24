# frozen_string_literal: true

class Guest::SkincareResumesController < ApplicationController
  def update
    session['resume_data'] ||= {}
    session['resume_data']['status'] = params[:status]

    redirect_to '/auth/google_oauth2'
  end

  def destroy
    session.delete('resume_data')
    redirect_to root_path
  end
end
