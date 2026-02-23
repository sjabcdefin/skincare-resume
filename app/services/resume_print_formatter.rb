# frozen_string_literal: true

class ResumePrintFormatter
  PRODUCTS_MAX_SIZE = 12
  MEDICATIONS_MAX_SIZE = 4
  ALLERGIES_MAX_SIZE = 4
  TREATMENTS_MAX_SIZE = 24

  def initialize(resume:)
    @resume = resume
  end

  def products
    products = @resume.products.order(:started_on)
    format(products, PRODUCTS_MAX_SIZE) { Product.new }
  end

  def medications
    medications = @resume.medications.order(:started_on)
    format(medications, MEDICATIONS_MAX_SIZE) { Medication.new }
  end

  def allergies
    allergies = @resume.allergies
    format(allergies, ALLERGIES_MAX_SIZE) { Allergy.new }
  end

  def treatments
    treatments = @resume.treatments.order(:treated_on)
    format(treatments, TREATMENTS_MAX_SIZE) { Treatment.new }
  end

  private

  def format(list, max, &block)
    list.to_a + Array.new([max - list.size, 0].max, &block)
  end
end
