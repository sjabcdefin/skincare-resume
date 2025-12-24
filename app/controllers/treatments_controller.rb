# frozen_string_literal: true

class TreatmentsController < ApplicationController
  before_action :set_treatment, only: %i[show edit update destroy]

  def index
    @treatments = fetch_treatments
  end

  def show; end

  def new
    @treatment = Treatment.new
  end

  def edit; end

  def create
    @treatment = build_treatment
    return unless @treatment.valid?

    save_treatment
    flash.now.notice = t('.success')
  end

  def update
    assign_treatment_params
    return unless @treatment.valid?

    save_updated_treatment
    flash.now.notice = t('.success')
  end

  def destroy
    destroy_treatment
    flash.now.notice = t('.success')
  end

  private

  def treatment_params
    params.require(:treatment).permit(:treated_on, :description)
  end

  def session_treatments
    session.dig('resume_data', 'treatments') || []
  end

  def set_treatment
    @treatment = current_user ? set_treatment_for_login : set_treatment_for_guest
  end

  def set_treatment_for_login
    Treatment.find(params[:id])
  end

  def set_treatment_for_guest
    attrs = session_treatments.find { |treatment| treatment['id'] == params[:id] }
    SessionTreatment.new(attrs)
  end

  def fetch_treatments
    current_user ? fetch_treatments_for_login : fetch_treatments_for_guest
  end

  def fetch_treatments_for_login
    Treatment.all.order(:treated_on)
  end

  def fetch_treatments_for_guest
    session_treatments
      .map { |attrs| SessionTreatment.new(attrs) }
      .sort_by { |m| [m.treated_on.nil? ? 0 : 1, m.treated_on] }
  end

  def build_treatment
    current_user ? build_treatment_for_login : build_treatment_for_guest
  end

  def build_treatment_for_login
    resume = find_or_create_resume
    resume.treatments.build(treatment_params)
  end

  def build_treatment_for_guest
    SessionTreatment.new(treatment_params.to_h)
  end

  def find_or_create_resume
    current_user.skincare_resume || current_user.create_skincare_resume!(status: :draft)
  end

  def save_treatment
    current_user ? save_treatment_for_login : save_treatment_for_guest
  end

  def save_treatment_for_login
    @treatment.save!
  end

  def save_treatment_for_guest
    @treatment.persisted = true
    session['resume_data'] ||= {}
    session['resume_data']['treatments'] ||= []
    session['resume_data']['treatments'] << @treatment.attributes.except('persisted')
  end

  def assign_treatment_params
    current_user ? assign_treatment_params_for_login : assign_treatment_params_for_guest
  end

  def assign_treatment_params_for_login
    @treatment.assign_attributes(treatment_params)
  end

  def assign_treatment_params_for_guest
    attrs = find_session_treatment
    new_attrs = attrs.merge(treatment_params.to_h)

    @treatment = SessionTreatment.new(new_attrs)
  end

  def save_updated_treatment
    current_user ? save_treatment_for_login : save_updated_treatment_for_guest
  end

  def save_updated_treatment_for_guest
    attrs = find_session_treatment
    attrs.merge!(treatment_params.to_h)
  end

  def find_session_treatment
    session_treatments.find { |treatment| treatment['id'] == params[:id] }
  end

  def destroy_treatment
    current_user ? @treatment.destroy! : destroy_treatment_for_guest
  end

  def destroy_treatment_for_guest
    session['resume_data']['treatments'].reject! { |treatment| treatment['id'] == params[:id] }
  end
end
