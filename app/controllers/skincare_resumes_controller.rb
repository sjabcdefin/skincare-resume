# frozen_string_literal: true

class SkincareResumesController < ApplicationController
  PRODUCTS_MAX_SIZE = 10
  MEDICATIONS_MAX_SIZE = 5
  ALLERGIES_MAX_SIZE = 5
  TREATMENTS_MAX_SIZE = 20

  def confirmation
    resume = current_user ? current_user.skincare_resume : current_resume

    products = resume ? resume.products.order(:started_on) : []
    medications = resume ? resume.medications.order(:started_on) : []
    allergies = resume ? resume.allergies : []
    treatments = resume ? resume.treatments.order(:treated_on) : []

    @products = format(products, PRODUCTS_MAX_SIZE) { Product.new }
    @medications = format(medications, MEDICATIONS_MAX_SIZE) { Medication.new }
    @allergies = format(allergies, ALLERGIES_MAX_SIZE) { Allergy.new }
    @treatments = format(treatments, TREATMENTS_MAX_SIZE) { Treatment.new }
  end

  def update
    @resume = current_user ? current_user.skincare_resume : current_resume
    redirect_path = current_user ? root_path : '/auth/google_oauth2'

    if @resume.update(status: params[:status])
      redirect_to redirect_path, notice: '履歴書の登録を完了しました。'
    else
      render :confirmation, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete('resume_uuid')
    redirect_to root_path
  end

  private

  def format(list, max, &block)
    list.to_a + Array.new([max - list.size, 0].max, &block)
  end

  def current_resume
    @session = session
    return nil unless @session['resume_uuid']

    SkincareResume.find_by(uuid: @session['resume_uuid'])
  end
end
