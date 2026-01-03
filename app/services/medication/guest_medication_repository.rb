# frozen_string_literal: true

class Medication::GuestMedicationRepository
  def initialize(session:)
    @session = session
  end

  def find(id)
    current_resume.medications.find(id)
  end

  def all
    current_resume ? current_resume.medications.order(:started_on) : []
  end

  def build(params)
    resume = current_resume
    resume ||= SkincareResume.create!(uuid: SecureRandom.uuid, status: :draft, user_id: nil)
    @session['resume_uuid'] = resume.uuid
    resume.medications.new(params)
  end

  private

  def current_resume
    return nil unless @session['resume_uuid']

    SkincareResume.find_by(uuid: @session['resume_uuid'])
  end
end
