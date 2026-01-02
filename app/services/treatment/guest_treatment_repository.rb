# frozen_string_literal: true

class Treatment::GuestTreatmentRepository
  def initialize(session:)
    @session = session
  end

  def find(id)
    attrs = session_treatments.find { |t| t['id'] == id }
    SessionTreatment.new(attrs)
  end

  def all
    session_treatments
      .map { |attrs| SessionTreatment.new(attrs) }
      .sort_by { |t| [t.treated_on.nil? ? 0 : 1, t.treated_on] }
  end

  def build(params)
    SessionTreatment.new(params.to_h)
  end

  def save(treatment)
    treatment.persisted = true
    @session['resume_data'] ||= {}
    @session['resume_data']['treatments'] ||= []
    @session['resume_data']['treatments'] << treatment.attributes
  end

  def assign(treatment, params)
    attrs = find_session_treatment(treatment.id)
    SessionTreatment.new(attrs.merge(params.to_h))
  end

  def update(treatment, params)
    attrs = find_session_treatment(treatment.id)
    attrs.merge!(params.to_h)
  end

  def destroy(treatment)
    @session['resume_data']['treatments'].reject! { |t| t['id'] == treatment.id }
  end

  private

  def session_treatments
    @session.dig('resume_data', 'treatments').to_a
  end

  def find_session_treatment(id)
    session_treatments.find { |t| t['id'] == id }
  end
end
