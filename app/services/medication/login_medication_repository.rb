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
    resume = @user.skincare_resume
    resume ||= @user.create_skincare_resume!(status: :draft)
    resume.medications.new(params)
  end
end
