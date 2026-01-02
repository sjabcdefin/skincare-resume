# frozen_string_literal: true

class MedicationsController < ApplicationController
  before_action :set_repository
  before_action :set_medication, only: %i[show edit update destroy]

  def index
    @medications = @repository.all
  end

  def show; end

  def new
    @medication = Medication.new
  end

  def edit; end

  def create
    @medication = @repository.build(medication_params)
    return unless @medication.valid?

    @repository.save(@medication)
    flash.now.notice = t('.success')
  end

  def update
    @medication = @repository.assign(@medication, medication_params)
    return unless @medication.valid?

    @repository.update(@medication, medication_params)
    flash.now.notice = t('.success')
  end

  def destroy
    @repository.destroy(@medication)
    flash.now.notice = t('.success')
  end

  private

  def set_repository
    @repository = if current_user
                    Medication::LoginMedicationRepository.new(user: current_user)
                  else
                    Medication::GuestMedicationRepository.new(session: session)
                  end
  end

  def set_medication
    @medication = @repository.find(params[:id])
  end

  def medication_params
    params.require(:medication).permit(:started_on, :name)
  end
end
