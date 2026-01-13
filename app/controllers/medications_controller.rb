# frozen_string_literal: true

class MedicationsController < ApplicationController
  before_action :set_medication, only: %i[show edit update destroy]

  def index
    resume = current_user&.skincare_resume
    @medications = resume ? resume.medications.order(:started_on) : []
  end

  def show; end

  def new
    @medication = Medication.new
  end

  def edit; end

  def create
    resume = current_user.skincare_resume
    resume ||= current_user.create_skincare_resume(status: :draft)
    @medication = resume.medications.new(medication_params)

    if @medication.save
      flash.now.notice = '薬の登録に成功しました。'
    else
      Rails.logger.info @medication.errors.full_messages
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
    @medication = current_user.skincare_resume.medications.find(params[:id])
  end

  def medication_params
    params.require(:medication).permit(:started_on, :name)
  end
end
