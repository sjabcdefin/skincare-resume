# frozen_string_literal: true

class TreatmentsController < ApplicationController
  before_action :set_treatment, only: %i[show edit update destroy]

  def index
    @treatments = current_user ? all_for_login : all_for_guest
  end

  def show; end

  def new
    @treatment = Treatment.new
  end

  def edit; end

  def create
    @treatment = current_user ? build_for_login : build_for_guest

    if @treatment.save
      flash.now.notice = '治療履歴の登録に成功しました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @treatment.update(treatment_params)
      flash.now.notice = '治療履歴の更新に成功しました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @treatment.destroy!
    flash.now.notice = '治療履歴の削除に成功しました。'
  end

  private

  def set_treatment
    @treatment = current_user ? find_for_login : find_for_guest
  end

  def treatment_params
    params.require(:treatment).permit(:treated_on, :name)
  end

  def find_for_login
    current_user.skincare_resume.treatments.find(params[:id])
  end

  def find_for_guest
    current_resume.treatments.find(params[:id])
  end

  def all_for_login
    resume = current_user&.skincare_resume
    resume ? resume.treatments.order(:treated_on) : []
  end

  def all_for_guest
    current_resume ? current_resume.treatments.order(:treated_on) : []
  end

  def build_for_login
    resume = current_user.skincare_resume
    resume ||= current_user.create_skincare_resume(status: :draft)
    resume.treatments.new(treatment_params)
  end

  def build_for_guest
    resume = current_resume
    resume ||= SkincareResume.create!(uuid: SecureRandom.uuid, status: :draft, user_id: nil)
    @session['resume_uuid'] = resume.uuid
    resume.treatments.new(treatment_params)
  end

  def current_resume
    @session = session
    return nil unless @session['resume_uuid']

    SkincareResume.find_by(uuid: @session['resume_uuid'])
  end
end
