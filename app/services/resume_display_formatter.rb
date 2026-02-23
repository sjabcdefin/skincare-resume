# frozen_string_literal: true

class ResumeDisplayFormatter
  def initialize(resume:)
    @resume = resume
  end

  def products
    @resume.products.order(:started_on)
  end

  def medications
    @resume.medications.order(:started_on)
  end

  delegate :allergies, to: :@resume

  def treatments
    @resume.treatments.order(:treated_on)
  end
end
