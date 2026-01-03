# frozen_string_literal: true

class Treatment::GuestTreatmentRepository
  def initialize(session:)
    @session = session
  end

  def find(id)
    current_resume.treatments.find(id)
  end

  def all
    current_resume ? current_resume.treatments.order(:treated_on) : []
  end

  def build(params)
    resume = current_resume
    resume ||= SkincareResume.create!(uuid: SecureRandom.uuid, status: :draft, user_id: nil)
    @session['resume_uuid'] = resume.uuid
    resume.treatments.new(params)
  end

  private

  def current_resume
    return nil unless @session['resume_uuid']

    SkincareResume.find_by(uuid: @session['resume_uuid'])
  end
end
