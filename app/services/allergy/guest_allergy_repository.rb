# frozen_string_literal: true

class Allergy::GuestAllergyRepository
  def initialize(session:)
    @session = session
  end

  def find(id)
    attrs = session_allergies.find { |a| a['id'] == id }
    SessionAllergy.new(attrs)
  end

  def all
    session_allergies
      .map { |attrs| SessionAllergy.new(attrs) }
  end

  def build(params)
    SessionAllergy.new(params.to_h)
  end

  def save(allergy)
    allergy.persisted = true
    @session['resume_data'] ||= {}
    @session['resume_data']['allergies'] ||= []
    @session['resume_data']['allergies'] << allergy.attributes
  end

  def assign(allergy, params)
    attrs = find_session_allergy(allergy.id)
    SessionAllergy.new(attrs.merge(params.to_h))
  end

  def update(allergy, params)
    attrs = find_session_allergy(allergy.id)
    attrs.merge!(params.to_h)
  end

  def destroy(allergy)
    @session['resume_data']['allergies'].reject! { |a| a['id'] == allergy.id }
  end

  private

  def session_allergies
    @session.dig('resume_data', 'allergies').to_a
  end

  def find_session_allergy(id)
    session_allergies.find { |a| a['id'] == id }
  end
end
