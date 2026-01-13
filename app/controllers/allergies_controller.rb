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

  # GET /allergies/1/edit
  def edit; end

  def create
    resume = current_user.skincare_resume
    resume ||= current_user.create_skincare_resume(status: :draft)
    @allergy = resume.allergies.new(allergy_params)

    if @allergy.save
      Rails.logger.info 'アレルギー歴の登録に成功しました。'
    else
      Rails.logger.info @allergy.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /allergies/1 or /allergies/1.json
  def update
    respond_to do |format|
      if @allergy.update(allergy_params)
        format.html { redirect_to @allergy, notice: 'Allergy was successfully updated.', status: :see_other }
        format.json { render :show, status: :ok, location: @allergy }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @allergy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /allergies/1 or /allergies/1.json
  def destroy
    @allergy.destroy!

    respond_to do |format|
      format.html { redirect_to allergies_path, notice: 'Allergy was successfully destroyed.', status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_allergy
    @allergy = Allergy.find(params.expect(:id))
  end

  def allergy_params
    params.require(:allergy).permit(:name)
  end
end
