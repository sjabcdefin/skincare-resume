# frozen_string_literal: true

class ResumeFormatter
  PRODUCTS_MAX_SIZE = 10
  MEDICATIONS_MAX_SIZE = 5
  ALLERGIES_MAX_SIZE = 5
  TREATMENTS_MAX_SIZE = 20

  def initialize(user:, session:)
    @resume = user ? user.skincare_resume : current_resume(session)
  end

  def products
    products = @resume ? @resume.products.order(:started_on) : []
    format(products, PRODUCTS_MAX_SIZE) { Product.new }
  end

  def medications
    medications = @resume ? @resume.medications.order(:started_on) : []
    format(medications, MEDICATIONS_MAX_SIZE) { Medication.new }
  end

  def allergies
    allergies = @resume ? @resume.allergies : []
    format(allergies, ALLERGIES_MAX_SIZE) { Allergy.new }
  end

  def treatments
    treatments = @resume ? @resume.treatments.order(:treated_on) : []
    format(treatments, TREATMENTS_MAX_SIZE) { Treatment.new }
  end

  private

  def format(list, max, &block)
    list.to_a + Array.new([max - list.size, 0].max, &block)
  end

  def current_resume(session)
    return nil unless session['resume_uuid']

    SkincareResume.find_by(uuid: session['resume_uuid'])
  end
end
