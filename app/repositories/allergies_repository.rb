# frozen_string_literal: true

class AllergiesRepository < ResumeBasedRepository
  def all
    current_resume&.allergies || Allergy.none
  end

  def find(id)
    raise ActiveRecord::RecordNotFound unless current_resume

    current_resume.allergies.find(id)
  end

  def build(params)
    writable_resume.allergies.build(params)
  end
end
