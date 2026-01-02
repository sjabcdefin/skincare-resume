# frozen_string_literal: true

class Medication::LoginMedicationRepository
  def initialize(user:)
    @user = user
  end

  def find(id)
    @user.skincare_resume.medications.find(id)
  end

  def all
    resume = @user.skincare_resume
    resume ? resume.medications.order(:started_on) : []
  end

  def build(params)
    resume = @user.skincare_resume || @user.create_skincare_resume!(status: :draft)
    resume.medications.build(params)
  end

  def save(medication)
    medication.save!
  end

  def assign(medication, params)
    medication.assign_attributes(params)
    medication
  end

  def update(medication, _params)
    medication.save!
  end

  def destroy(medication)
    medication.destroy!
  end
end
