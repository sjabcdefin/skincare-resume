# frozen_string_literal: true

class MedicationsController < ApplicationController
  before_action :set_medication, only: %i[show edit update destroy]

  def index
    resume = current_user&.skincare_resume
    @medications = resume ? resume.medications.order(:started_on) : []
  end

  # GET /medications/1 or /medications/1.json
  def show; end

  def new
    @medication = Medication.new
  end

  # GET /medications/1/edit
  def edit; end

  def create
    resume = current_user.skincare_resume
    resume ||= current_user.create_skincare_resume(status: :draft)
    @medication = resume.medications.new(medication_params)

    if @medication.save
      Rails.logger.info '薬の登録に成功しました。'
    else
      Rails.logger.info @medication.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /medications/1 or /medications/1.json
  def update
    respond_to do |format|
      if @medication.update(medication_params)
        format.html { redirect_to @medication, notice: 'Medication was successfully updated.', status: :see_other }
        format.json { render :show, status: :ok, location: @medication }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @medication.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /medications/1 or /medications/1.json
  def destroy
    @medication.destroy!

    respond_to do |format|
      format.html { redirect_to medications_path, notice: 'Medication was successfully destroyed.', status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_medication
    @medication = Medication.find(params.expect(:id))
  end

  def medication_params
    params.require(:medication).permit(:started_on, :name)
  end
end
