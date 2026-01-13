# frozen_string_literal: true

class TreatmentsController < ApplicationController
  before_action :set_treatment, only: %i[show edit update destroy]

  def index
    resume = current_user&.skincare_resume
    @treatments = resume ? resume.treatments.order(:treated_on) : []
  end

  # GET /treatments/1 or /treatments/1.json
  def show; end

  def new
    @treatment = Treatment.new
  end

  def edit; end

  def create
    resume = current_user.skincare_resume
    resume ||= current_user.create_skincare_resume(status: :draft)
    @treatment = resume.treatments.new(treatment_params)

    if @treatment.save
      flash.now.notice = '治療履歴の登録に成功しました。'
    else
      Rails.logger.info @treatment.errors.full_messages
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
    @treatment = current_user.skincare_resume.treatments.find(params[:id])
  end

  def treatment_params
    params.require(:treatment).permit(:treated_on, :name)
  end
end
