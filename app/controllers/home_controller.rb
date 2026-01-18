# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @resume_status = 'before_login'
  end

  private

  def decide_resume_state
    return 'before_login' unless current_user
  end
end
