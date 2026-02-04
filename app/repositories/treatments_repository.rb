# frozen_string_literal: true

class TreatmentsRepository < ResumeBasedRepository
  def all
    current_resume&.treatments&.order(:treated_on) || Treatment.none
  end

  def find(id)
    current_resume&.treatments&.find(id)
  end

  def build(params)
    writable_resume.treatments.build(params)
  end
end
