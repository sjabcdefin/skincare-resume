# frozen_string_literal: true

class MedicationsRepository
  def initialize(user:, session:)
    @user = user
    @session = session
  end

  def all
    current_resume&.medications&.order(:started_on) || Medication.none
  end

  def find(id)
    current_resume&.medications&.find(id)
  end

  def build(params)
    writable_resume.medications.build(params)
  end

  private

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

  def writable_resume
    @writable_resume ||= @user ? ensure_login_resume : ensure_guest_resume
  end

  def ensure_login_resume
    return login_resume if login_resume

    @user.create_skincare_resume(status: :draft)
  end

  def ensure_guest_resume
    return guest_resume if guest_resume

    resume = SkincareResume.create!(
      uuid: SecureRandom.uuid,
      status: :draft,
      user_id: nil
    )
    @session['resume_uuid'] = resume.uuid
    resume
  end
end
