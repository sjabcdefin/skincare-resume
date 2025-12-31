# frozen_string_literal: true

class ResumeFormatter
  PRODUCTS_MAX_SIZE = 10
  MEDICATIONS_MAX_SIZE = 5
  ALLERGIES_MAX_SIZE = 5
  TREATMENTS_MAX_SIZE = 20

  def initialize(user:, session:)
    @user = user
    @session = session
  end

  def products
    list = @user ? @user.skincare_resume.products.order(:started_on) : guest_products
    format(list, PRODUCTS_MAX_SIZE) { Product.new }
  end

  def medications
    list = @user ? @user.skincare_resume.medications.order(:started_on) : guest_medications
    format(list, MEDICATIONS_MAX_SIZE) { Medication.new }
  end

  def allergies
    list = @user ? @user.skincare_resume.allergies : guest_allergies
    format(list, ALLERGIES_MAX_SIZE) { Allergy.new }
  end

  def treatments
    list = @user ? @user.skincare_resume.treatments.order(:treated_on) : guest_treatments
    format(list, TREATMENTS_MAX_SIZE) { Treatment.new }
  end

  private

  def format(list, max, &block)
    list.to_a + Array.new([max - list.size, 0].max, &block)
  end

  def guest_products
    @session.dig('resume_data', 'products').to_a
            .map { |attrs| SessionProduct.new(attrs) }
            .sort_by { |p| [p.started_on.nil? ? 0 : 1, p.started_on] }
  end

  def guest_medications
    @session.dig('resume_data', 'medications').to_a
            .map { |attrs| SessionMedication.new(attrs) }
            .sort_by { |m| [m.started_on.nil? ? 0 : 1, m.started_on] }
  end

  def guest_allergies
    @session.dig('resume_data', 'allergies').to_a
            .map { |attrs| SessionAllergy.new(attrs) }
  end

  def guest_treatments
    @session.dig('resume_data', 'treatments').to_a
            .map { |attrs| SessionTreatment.new(attrs) }
            .sort_by { |t| [t.treated_on.nil? ? 0 : 1, t.treated_on] }
  end
end
