# frozen_string_literal: true

class ResumeDisplayFormatter
  def initialize(resume:)
    @resume = resume
  end

  def products
    products = @resume.products || Product.none
    products.order_for_display
  end

  def medications
    medications = @resume.medications || Medication.none
    medications.order_for_display
  end

  delegate :allergies, to: :@resume

  def treatments
    treatments = @resume.treatments || Treatment.none
    treatments.order_for_display
  end
end
