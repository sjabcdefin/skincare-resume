# frozen_string_literal: true

class MedicationsRepository < ResumeBasedRepository
  def all
    current_resume&.medications&.order(:started_on) || Medication.none
  end

  def find(id)
    current_resume&.medications&.find(id)
  end

  def build(params)
    current_resume.medications.build(params)
  end
end
