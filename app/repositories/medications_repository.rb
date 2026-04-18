# frozen_string_literal: true

class MedicationsRepository < ResumeBasedRepository
  def all
    current_resume&.medications || Medication.none
  end

  def find(id)
    raise ActiveRecord::RecordNotFound unless current_resume

    current_resume.medications.find(id)
  end

  def build(params)
    writable_resume.medications.build(params)
  end
end
