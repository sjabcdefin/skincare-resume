# frozen_string_literal: true

class ConfirmationController < ApplicationController
  PRODUCTS_MAX_SIZE = 10
  MEDICATIONS_MAX_SIZE = 5
  ALLERGIES_MAX_SIZE = 5
  TREATMENTS_MAX_SIZE = 20

  before_action :set_resume, only: :show

  def show
    @products = Product.all.order(:started_on)
    @medications = Medication.all.order(:started_on)
    @allergies = Allergy.all
    @treatments = Treatment.all.order(:treated_on)

    @products = @products.to_a + Array.new([PRODUCTS_MAX_SIZE - @products.size, 0].max) { Product.new }
    @medications = @medications.to_a + Array.new([MEDICATIONS_MAX_SIZE - @medications.size, 0].max) { Medication.new }
    @allergies = @allergies.to_a + Array.new([ALLERGIES_MAX_SIZE - @allergies.size, 0].max) { Allergy.new }
    @treatments = @treatments.to_a + Array.new([TREATMENTS_MAX_SIZE - @treatments.size, 0].max) { Treatment.new }
  end

  private

  def set_resume
    @resume = current_user.skincare_resume if current_user.skincare_resume
  end
end
