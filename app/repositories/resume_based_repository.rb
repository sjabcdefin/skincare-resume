# frozen_string_literal: true

class ResumeBasedRepository
  def initialize(user:, session:)
    @user = user
    @session = session
  end

  def resume
    current_resume
  end

  def build
    @user ? build_login_resume : build_guest_resume
  end

  protected

  def current_resume
    @current_resume ||= @user ? login_resume : guest_resume
  end

  def login_resume
    @user.skincare_resume
  end

  def guest_resume
    return nil unless @session['resume_uuid']

    SkincareResume.find_by(uuid: @session['resume_uuid'])
  end

  def build_login_resume
    @user.build_skincare_resume(status: :draft)
  end

  def build_guest_resume
    SkincareResume.new(
      uuid: SecureRandom.uuid,
      status: :draft,
      user_id: nil
    )
  end
end
