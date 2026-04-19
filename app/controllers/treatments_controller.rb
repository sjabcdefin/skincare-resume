# frozen_string_literal: true

class TreatmentsController < ApplicationController
  before_action :set_resume, only: %i[index create edit update destroy]
  before_action :set_treatment, only: %i[edit update destroy]

  def index
    @treatments = @resume&.treatments&.order_for_display || Treatment.none
  end

  def new
    @treatment = Treatment.new
  end

  def edit; end

  def create
    @resume ||= build_resume
    @treatment = @resume.treatments.build(treatment_params)

    if @treatment.save
      render :create
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @treatment.update(treatment_params)
      render :update
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @treatment.destroy!
    render :destroy
  end

  private

  def set_resume
    @resume = ResumeResolver.new(user: current_user, session: session).call
  end

  def set_treatment
    raise ActiveRecord::RecordNotFound unless @resume

    @treatment = @resume.treatments.find(params[:id])
  end

  def treatment_params
    params.require(:treatment).permit(:treated_on, :name)
  end
end
