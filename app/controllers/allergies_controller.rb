# frozen_string_literal: true

class AllergiesController < ApplicationController
  before_action :set_allergy, only: %i[show edit update destroy]

  def index
    resume = current_user&.skincare_resume
    @allergies = resume ? resume.allergies : []
  end

  # GET /allergies/1 or /allergies/1.json
  def show; end

  def new
    @allergy = Allergy.new
  end

  def edit; end

  def create
    resume = current_user.skincare_resume
    resume ||= current_user.create_skincare_resume(status: :draft)
    @allergy = resume.allergies.new(allergy_params)

    if @allergy.save
      flash.now.notice = 'アレルギー歴の登録に成功しました。'
    else
      Rails.logger.info @allergy.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @allergy.update(allergy_params)
      flash.now.notice = 'アレルギー歴の更新に成功しました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @allergy.destroy!
    flash.now.notice = 'アレルギー歴の削除に成功しました。'
  end

  private

  def set_allergy
    @allergy = current_user.skincare_resume.allergies.find(params[:id])
  end

  def allergy_params
    params.require(:allergy).permit(:name)
  end
end
