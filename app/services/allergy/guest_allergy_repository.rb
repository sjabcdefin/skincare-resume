# frozen_string_literal: true

class Allergy::GuestAllergyRepository
  def initialize(session:)
    @session = session
  end

  def find(id)
    current_resume.allergies.find(id)
  end

  def all
    current_resume ? current_resume.allergies : []
  end

  def build(params)
    resume = current_resume
    resume ||= SkincareResume.create!(uuid: SecureRandom.uuid, status: :draft, user_id: nil)
    @session['resume_uuid'] = resume.uuid
    resume.allergies.new(params)
  end

  private

  def current_resume
    return nil unless @session['resume_uuid']

    SkincareResume.find_by(uuid: @session['resume_uuid'])
  end
end
