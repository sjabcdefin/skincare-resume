# frozen_string_literal: true

class ResumeBasedRepository
  def initialize(user:, session:)
    @user = user
    @session = session
  end

  def resume
    current_resume
  end

  protected

  def current_resume
    @current_resume ||= @user ? login_resume : guest_resume
  end

  def writable_resume
    return current_resume if current_resume

    @user ? create_login_resume : create_guest_resume
  end

  private

  def login_resume
    @user.skincare_resume
  end

  def guest_resume
    return nil unless @session['resume_uuid']

    SkincareResume.find_by(uuid: @session['resume_uuid'])
  end

  def create_login_resume
    @user.create_skincare_resume!(status: :draft)
  end

  def create_guest_resume
    resume = SkincareResume.create!(
      uuid: SecureRandom.uuid,
      status: :draft,
      user_id: nil
    )
    @session['resume_uuid'] = resume.uuid
    resume
  end
end
