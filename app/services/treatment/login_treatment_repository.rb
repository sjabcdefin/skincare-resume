# frozen_string_literal: true

class Treatment::LoginTreatmentRepository
  def initialize(user:)
    @user = user
  end

  def find(id)
    @user.skincare_resume.treatments.find(id)
  end

  def all
    resume = @user.skincare_resume
    resume ? resume.treatments.order(:treated_on) : []
  end

  def build(params)
    resume = @user.skincare_resume || @user.create_skincare_resume!(status: :draft)
    resume.treatments.build(params)
  end

  def save(treatment)
    treatment.save!
  end

  def assign(treatment, params)
    treatment.assign_attributes(params)
    treatment
  end

  def update(treatment, _params)
    treatment.save!
  end

  def destroy(treatment)
    treatment.destroy!
  end
end
