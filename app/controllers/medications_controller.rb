# frozen_string_literal: true

class MedicationsController < ApplicationController
  before_action :set_medication, only: %i[show edit update destroy]

  def index
    @resume = repository.resume
    @medications = repository.all.order_for_display
  end

  def show; end

  def new
    @medication = Medication.new
  end

  def edit; end

  def create
    @medication = repository.build(medication_params)
    @resume = repository.resume

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

  def repository
    @repository ||= MedicationsRepository.new(
      user: current_user,
      session: session
    )
  end

  def set_medication
    @medication = repository.find(params[:id])
  end

  def medication_params
    params.require(:medication).permit(:started_on, :name)
  end
end
