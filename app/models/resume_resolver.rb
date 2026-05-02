# frozen_string_literal: true

class ResumeResolver
  def initialize(user:, session:)
    @user = user
    @session = session
  end

  def call
    resume
  end

  private

  def resume
    @user ? login_resume : guest_resume
  end

  def login_resume
    @user.skincare_resume
  end

  def guest_resume
    return nil unless @session['resume_uuid']

    SkincareResume.find_by(uuid: @session['resume_uuid'])
  end
end
