# frozen_string_literal: true

class AllergiesController < ApplicationController
  before_action :set_allergy, only: %i[show edit update destroy]

  def index
    @allergies = fetch_allergies
  end

  def show; end

  def new
    @allergy = Allergy.new
  end

  def edit; end

  def create
    @allergy = build_allergy
    return unless @allergy.valid?

    save_allergy
    flash.now.notice = t('.success')
  end

  def update
    assign_allergy_params
    return unless @allergy.valid?

    save_updated_allergy
    flash.now.notice = t('.success')
  end

  def destroy
    destroy_allergy
    flash.now.notice = t('.success')
  end

  private

  def allergy_params
    params.require(:allergy).permit(:name)
  end

  def session_allergies
    session.dig('resume_data', 'allergies') || []
  end

  def set_allergy
    @allergy = current_user ? set_allergy_for_login : set_allergy_for_guest
  end

  def set_allergy_for_login
    Allergy.find(params[:id])
  end

  def set_allergy_for_guest
    attrs = session_allergies.find { |allergy| allergy['id'] == params[:id] }
    SessionAllergy.new(attrs)
  end

  def fetch_allergies
    current_user ? fetch_allergies_for_login : fetch_allergies_for_guest
  end

  def fetch_allergies_for_login
    Allergy.all
  end

  def fetch_allergies_for_guest
    session_allergies
      .map { |attrs| SessionAllergy.new(attrs) }
  end

  def build_allergy
    current_user ? build_allergy_for_login : build_allergy_for_guest
  end

  def build_allergy_for_login
    resume = find_or_create_resume
    resume.allergies.build(allergy_params)
  end

  def build_allergy_for_guest
    SessionAllergy.new(allergy_params.to_h)
  end

  def find_or_create_resume
    current_user.skincare_resume || current_user.create_skincare_resume!(status: :draft)
  end

  def save_allergy
    current_user ? save_allergy_for_login : save_allergy_for_guest
  end

  def save_allergy_for_login
    @allergy.save!
  end

  def save_allergy_for_guest
    @allergy.persisted = true
    session['resume_data'] ||= {}
    session['resume_data']['allergies'] ||= []
    session['resume_data']['allergies'] << @allergy.attributes.except('persisted')
  end

  def assign_allergy_params
    current_user ? assign_allergy_params_for_login : assign_allergy_params_for_guest
  end

  def assign_allergy_params_for_login
    @allergy.assign_attributes(allergy_params)
  end

  def assign_allergy_params_for_guest
    attrs = find_session_allergy
    new_attrs = attrs.merge(allergy_params.to_h)

    @allergy = SessionAllergy.new(new_attrs)
  end

  def save_updated_allergy
    current_user ? save_allergy_for_login : save_updated_allergy_for_guest
  end

  def save_updated_allergy_for_guest
    attrs = find_session_allergy
    attrs.merge!(allergy_params.to_h)
  end

  def find_session_allergy
    session_allergies.find { |allergy| allergy['id'] == params[:id] }
  end

  def destroy_allergy
    current_user ? @allergy.destroy! : destroy_allergy_for_guest
  end

  def destroy_allergy_for_guest
    session['resume_data']['allergies'].reject! { |allergy| allergy['id'] == params[:id] }
  end
end
