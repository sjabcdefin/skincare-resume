# frozen_string_literal: true

class SkincareResumesController < ApplicationController
  PRODUCTS_MAX_SIZE = 10
  MEDICATIONS_MAX_SIZE = 5
  ALLERGIES_MAX_SIZE = 5
  TREATMENTS_MAX_SIZE = 20

  def confirmation
    @products = current_user ? Product.order(:started_on) : guest_products
    @medications = current_user ? Medication.order(:started_on) : guest_medications
    @allergies = current_user ? Allergy.all : guest_allergies
    @treatments = current_user ? Treatment.order(:treated_on) : guest_treatments

    @products = @products.to_a + Array.new([PRODUCTS_MAX_SIZE - @products.size, 0].max) { Product.new }
    @medications = @medications.to_a + Array.new([MEDICATIONS_MAX_SIZE - @medications.size, 0].max) { Medication.new }
    @allergies = @allergies.to_a + Array.new([ALLERGIES_MAX_SIZE - @allergies.size, 0].max) { Allergy.new }
    @treatments = @treatments.to_a + Array.new([TREATMENTS_MAX_SIZE - @treatments.size, 0].max) { Treatment.new }
  end

  def update
    current_user ? update_status_for_login : update_status_for_guest
  end

  def destroy
    session.delete('resume_data')
    redirect_to root_path
  end

  private

  def guest_products
    session.dig('resume_data', 'products').to_a
           .map { |attrs| SessionProduct.new(attrs) }
           .sort_by { |p| [p.started_on.nil? ? 0 : 1, p.started_on] }
  end

  def guest_medications
    session.dig('resume_data', 'medications').to_a
           .map { |attrs| SessionMedication.new(attrs) }
           .sort_by { |m| [m.started_on.nil? ? 0 : 1, m.started_on] }
  end

  def guest_allergies
    session.dig('resume_data', 'allergies').to_a
           .map { |attrs| SessionAllergy.new(attrs) }
  end

  def guest_treatments
    session.dig('resume_data', 'treatments').to_a
           .map { |attrs| SessionTreatment.new(attrs) }
           .sort_by { |t| [t.treated_on.nil? ? 0 : 1, t.treated_on] }
  end

  def update_status_for_login
    @resume = current_user.skincare_resume

    if @resume.update(status: params[:status])
      redirect_to root_path, notice: t('.success')
    else
      render '/skincare_resume/confirmation', status: :unprocessable_entity
    end
  end

  def update_status_for_guest
    session['resume_data'] ||= {}
    session['resume_data']['status'] = params[:status]

    redirect_to '/auth/google_oauth2'
  end
end
