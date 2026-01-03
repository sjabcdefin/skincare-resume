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
    resume = @user.skincare_resume
    resume ||= @user.create_skincare_resume!(status: :draft)
    resume.allergies.new(params)
  end
end
