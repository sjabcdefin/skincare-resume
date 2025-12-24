# frozen_string_literal: true

class ConfirmationController < ApplicationController
  PRODUCTS_MAX_SIZE = 10
  MEDICATIONS_MAX_SIZE = 5
  ALLERGIES_MAX_SIZE = 5
  TREATMENTS_MAX_SIZE = 20

  def show
    @resume = current_user.skincare_resume if current_user
    @products = products
    @medications = medications
    @allergies = allergies
    @treatments = treatments

    @products = @products.to_a + Array.new([PRODUCTS_MAX_SIZE - @products.size, 0].max) { Product.new }
    @medications = @medications.to_a + Array.new([MEDICATIONS_MAX_SIZE - @medications.size, 0].max) { Medication.new }
    @allergies = @allergies.to_a + Array.new([ALLERGIES_MAX_SIZE - @allergies.size, 0].max) { Allergy.new }
    @treatments = @treatments.to_a + Array.new([TREATMENTS_MAX_SIZE - @treatments.size, 0].max) { Treatment.new }
  end

  private

  def products
    current_user ? Product.all.order(:started_on) : guest_products
  end

  def guest_products
    session_products.map { |attrs| SessionProduct.new(attrs) }
                    .sort_by { |p| [p.started_on.nil? ? 0 : 1, p.started_on] }
  end

  def session_products
    session.dig('resume_data', 'products') || []
  end

  def medications
    current_user ? Medication.all.order(:started_on) : guest_medications
  end

  def guest_medications
    session_medications.map { |attrs| SessionMedication.new(attrs) }
                       .sort_by { |m| [m.started_on.nil? ? 0 : 1, m.started_on] }
  end

  def session_medications
    session.dig('resume_data', 'medications') || []
  end

  def allergies
    current_user ? Allergy.all : guest_allergies
  end

  def guest_allergies
    session_allergies.map { |attrs| SessionAllergy.new(attrs) }
  end

  def session_allergies
    session.dig('resume_data', 'allergies') || []
  end

  def treatments
    current_user ? Treatment.all.order(:treated_on) : guest_treatments
  end

  def guest_treatments
    session_treatments.map { |attrs| SessionTreatment.new(attrs) }
                      .sort_by { |t| [t.treated_on.nil? ? 0 : 1, t.treated_on] }
  end

  def session_treatments
    session.dig('resume_data', 'treatments') || []
  end
end
