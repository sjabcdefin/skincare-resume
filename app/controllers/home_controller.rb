# frozen_string_literal: true

class HomeController < ApplicationController
  PRODUCTS_MAX_SIZE = 10
  MEDICATIONS_MAX_SIZE = 5
  ALLERGIES_MAX_SIZE = 5
  TREATMENTS_MAX_SIZE = 20

  def index
    @resume = current_user&.skincare_resume
    @resume_status = decide_resume_state
    format_resume if current_user
  end

  private

  def decide_resume_state
    return 'before_login' unless current_user
    return 'no_resume' unless @resume

    case @resume.status
    when 'draft'
      'draft_resume'
    end
  end

  def format_resume
    products = @resume ? @resume.products.order(:started_on) : []
    medications = @resume ? @resume.medications.order(:started_on) : []
    allergies = @resume ? @resume.allergies : []
    treatments = @resume ? @resume.treatments.order(:treated_on) : []

    @products = format(products, PRODUCTS_MAX_SIZE) { Product.new }
    @medications = format(medications, MEDICATIONS_MAX_SIZE) { Medication.new }
    @allergies = format(allergies, ALLERGIES_MAX_SIZE) { Allergy.new }
    @treatments = format(treatments, TREATMENTS_MAX_SIZE) { Treatment.new }
  end

  def format(list, max, &block)
    list.to_a + Array.new([max - list.size, 0].max, &block)
  end
end
