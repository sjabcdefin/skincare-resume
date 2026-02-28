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
      flash.now.notice = t('flash.create.success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @medication.update(medication_params)
      flash.now.notice = t('flash.update.success')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @medication.destroy!
    flash.now.notice = t('flash.destroy.success')
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
