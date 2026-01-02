# frozen_string_literal: true

class Medication::GuestMedicationRepository
  def initialize(session:)
    @session = session
  end

  def find(id)
    attrs = session_medications.find { |m| m['id'] == id }
    SessionMedication.new(attrs)
  end

  def all
    session_medications
      .map { |attrs| SessionMedication.new(attrs) }
      .sort_by { |m| [m.started_on.nil? ? 0 : 1, m.started_on] }
  end

  def build(params)
    SessionMedication.new(params.to_h)
  end

  def save(medication)
    medication.persisted = true
    @session['resume_data'] ||= {}
    @session['resume_data']['medications'] ||= []
    @session['resume_data']['medications'] << medication.attributes
  end

  def assign(medication, params)
    attrs = find_session_medication(medication.id)
    SessionMedication.new(attrs.merge(params.to_h))
  end

  def update(medication, params)
    attrs = find_session_medication(medication.id)
    attrs.merge!(params.to_h)
  end

  def destroy(medication)
    @session['resume_data']['medications'].reject! { |m| m['id'] == medication.id }
  end

  private

  def session_medications
    @session.dig('resume_data', 'medications').to_a
  end

  def find_session_medication(id)
    session_medications.find { |m| m['id'] == id }
  end
end
