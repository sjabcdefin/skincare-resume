# frozen_string_literal: true

class TreatmentsController < ApplicationController
  before_action :set_treatment, only: %i[show edit update destroy]

  def index
    @resume = repository.resume
    @treatments = repository.all.order_for_display
  end

  def show; end

  def new
    @treatment = Treatment.new
  end

  def edit; end

  def create
    @treatment = repository.build(treatment_params)
    @resume = repository.resume

    if @treatment.save
      flash.now.notice = t('flash.create.success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @treatment.update(treatment_params)
      flash.now.notice = t('flash.update.success')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @treatment.destroy!
    flash.now.notice = t('flash.destroy.success')
  end

  private

  def repository
    @repository ||= TreatmentsRepository.new(
      user: current_user,
      session: session
    )
  end

  def set_treatment
    @treatment = repository.find(params[:id])
  end

  def treatment_params
    params.require(:treatment).permit(:treated_on, :name)
  end
end
