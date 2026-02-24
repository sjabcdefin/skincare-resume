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
    products = @resume.products || Product.none
    sorted_products = products.order_for_print.limit(PRODUCTS_MAX_SIZE).reverse
    format(sorted_products, PRODUCTS_MAX_SIZE) { Product.new }
  end

  def medications
    medications = @resume.medications || Medication.none
    sorted_medications = medications.order_for_print.limit(MEDICATIONS_MAX_SIZE).reverse
    format(sorted_medications, MEDICATIONS_MAX_SIZE) { Medication.new }
  end

  def allergies
    allergies = @resume.allergies || Allergy.none
    limited_allergies = allergies.limit(ALLERGIES_MAX_SIZE)
    format(limited_allergies, ALLERGIES_MAX_SIZE) { Allergy.new }
  end

  def treatments
    treatments = @resume.treatments || Treatment.none
    sorted_treatments = treatments.order_for_print.limit(TREATMENTS_MAX_SIZE).reverse
    format(sorted_treatments, TREATMENTS_MAX_SIZE) { Treatment.new }
  end

  private

  def format(list, max, &block)
    list.to_a + Array.new([max - list.size, 0].max, &block)
  end
end
