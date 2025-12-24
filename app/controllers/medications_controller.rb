# frozen_string_literal: true

class MedicationsController < ApplicationController
  before_action :set_medication, only: %i[show edit update destroy]

  def index
    @medications = fetch_medications
  end

  def show; end

  def new
    @medication = Medication.new
  end

  def edit; end

  def create
    @medication = build_medication
    return unless @medication.valid?

    save_medication
    flash.now.notice = t('.success')
  end

  def update
    assign_medication_params
    return unless @medication.valid?

    save_updated_medication
    flash.now.notice = t('.success')
  end

  def destroy
    destroy_medication
    flash.now.notice = t('.success')
  end

  private

  def medication_params
    params.require(:medication).permit(:started_on, :name)
  end

  def session_medications
    session.dig('resume_data', 'medications') || []
  end

  def set_medication
    @medication = current_user ? set_medication_for_login : set_medication_for_guest
  end

  def set_medication_for_login
    Medication.find(params[:id])
  end

  def set_medication_for_guest
    attrs = session_medications.find { |medication| medication['id'] == params[:id] }
    SessionMedication.new(attrs)
  end

  def fetch_medications
    current_user ? fetch_medications_for_login : fetch_medications_for_guest
  end

  def fetch_medications_for_login
    Medication.all.order(:started_on)
  end

  def fetch_medications_for_guest
    session_medications
      .map { |attrs| SessionMedication.new(attrs) }
      .sort_by { |m| [m.started_on.nil? ? 0 : 1, m.started_on] }
  end

  def build_medication
    current_user ? build_medication_for_login : build_medication_for_guest
  end

  def build_medication_for_login
    resume = find_or_create_resume
    resume.medications.build(medication_params)
  end

  def build_medication_for_guest
    SessionMedication.new(medication_params.to_h)
  end

  def find_or_create_resume
    current_user.skincare_resume || current_user.create_skincare_resume!(status: :draft)
  end

  def save_medication
    current_user ? save_medication_for_login : save_medication_for_guest
  end

  def save_medication_for_login
    @medication.save!
  end

  def save_medication_for_guest
    @medication.persisted = true
    session['resume_data'] ||= {}
    session['resume_data']['medications'] ||= []
    session['resume_data']['medications'] << @medication.attributes.except('persisted')
  end

  def assign_medication_params
    current_user ? assign_medication_params_for_login : assign_medication_params_for_guest
  end

  def assign_medication_params_for_login
    @medication.assign_attributes(medication_params)
  end

  def assign_medication_params_for_guest
    attrs = find_session_medication
    new_attrs = attrs.merge(medication_params.to_h)

    @medication = SessionMedication.new(new_attrs)
  end

  def save_updated_medication
    current_user ? save_medication_for_login : save_updated_medication_for_guest
  end

  def save_updated_medication_for_guest
    attrs = find_session_medication
    attrs.merge!(medication_params.to_h)
  end

  def find_session_medication
    session_medications.find { |medication| medication['id'] == params[:id] }
  end

  def destroy_medication
    current_user ? @medication.destroy! : destroy_medication_for_guest
  end

  def destroy_medication_for_guest
    session['resume_data']['medications'].reject! { |medication| medication['id'] == params[:id] }
  end
end
