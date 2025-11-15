# frozen_string_literal: true

class MedicationsController < ApplicationController
  before_action :set_medication, only: %i[show edit update destroy]

  def index
    @medications = Medication.all.order(:started_on)
  end

  def show; end

  def new
    @medication = Medication.new
  end

  def edit; end

  def create
    @medication = Medication.new(medication_params)

    if @medication.save
      flash.now.notice = t('.success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @medication.update(medication_params)
      flash.now.notice = t('.success')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @medication.destroy!
    flash.now.notice = t('.success')
  end

  private

  def set_medication
    @medication = Medication.find(params[:id])
  end

  def medication_params
    params.require(:medication).permit(:started_on, :name)
  end
end
