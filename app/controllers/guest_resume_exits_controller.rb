# frozen_string_literal: true

class GuestResumeExitsController < ApplicationController
  def destroy
    session.delete('resume_data')
    redirect_to root_path
  end
end
