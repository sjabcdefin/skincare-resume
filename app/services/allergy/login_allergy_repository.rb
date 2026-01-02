# frozen_string_literal: true

class Allergy::LoginAllergyRepository
  def initialize(user:)
    @user = user
  end

  def find(id)
    @user.skincare_resume.allergies.find(id)
  end

  def all
    resume = @user.skincare_resume
    resume ? resume.allergies : []
  end

  def build(params)
    resume = @user.skincare_resume || @user.create_skincare_resume!(status: :draft)
    resume.allergies.build(params)
  end

  def save(allergy)
    allergy.save!
  end

  def assign(allergy, params)
    allergy.assign_attributes(params)
    allergy
  end

  def update(allergy, _params)
    allergy.save!
  end

  def destroy(allergy)
    allergy.destroy!
  end
end
