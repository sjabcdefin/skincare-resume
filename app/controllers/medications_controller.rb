# frozen_string_literal: true

class MedicationsController < ApplicationController
  before_action :set_medication, only: %i[show edit update destroy]

  def index
    @medications = current_user ? all_for_login : all_for_guest
  end

  def show; end

  def new
    @medication = Medication.new
  end

  def edit; end

  def create
    @medication = current_user ? build_for_login : build_for_guest

    if @medication.save
      flash.now.notice = '薬の登録に成功しました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @medication.update(medication_params)
      flash.now.notice = '薬の更新に成功しました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @medication.destroy!
    flash.now.notice = '薬の削除に成功しました。'
  end

  private

  def set_medication
    @medication = current_user ? find_for_login : find_for_guest
  end

  def medication_params
    params.require(:medication).permit(:started_on, :name)
  end

  def find_for_login
    current_user.skincare_resume.medications.find(params[:id])
  end

  def find_for_guest
    current_resume.medications.find(params[:id])
  end

  def all_for_login
    resume = current_user&.skincare_resume
    resume ? resume.medications.order(:started_on) : []
  end

  def all_for_guest
    current_resume ? current_resume.medications.order(:started_on) : []
  end

  def build_for_login
    resume = current_user.skincare_resume
    resume ||= current_user.create_skincare_resume(status: :draft)
    resume.medications.new(medication_params)
  end

  def build_for_guest
    resume = current_resume
    resume ||= SkincareResume.create!(uuid: SecureRandom.uuid, status: :draft, user_id: nil)
    @session['resume_uuid'] = resume.uuid
    resume.medications.new(medication_params)
  end

  def current_resume
    @session = session
    return nil unless @session['resume_uuid']

    SkincareResume.find_by(uuid: @session['resume_uuid'])
  end
end
