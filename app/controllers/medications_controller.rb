# frozen_string_literal: true

class MedicationsController < ApplicationController
  before_action :set_resume, only: %i[index create edit update destroy]
  before_action :set_medication, only: %i[edit update destroy]

  def index
    @medications = @resume&.medications&.order_for_display || Medication.none
  end

  def new
    @medication = Medication.new
  end

  def edit; end

  def create
    @resume ||= build_resume
    @medication = @resume.medications.build(medication_params)

    if @medication.save
      render :create
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @medication.update(medication_params)
      render :update
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @medication.destroy!
    render :destroy
  end

  private

  def set_medication
    raise ActiveRecord::RecordNotFound unless @resume

    @medication = @resume.medications.find(params[:id])
  end

  def medication_params
    params.require(:medication).permit(:started_on, :name)
  end
end
