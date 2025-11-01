# frozen_string_literal: true

class TreatmentsController < ApplicationController
  before_action :set_treatment, only: %i[show edit update destroy]

  def index
    @treatments = Treatment.all
  end

  def show; end

  def new
    @treatment = Treatment.new
  end

  def edit; end

  def create
    @treatment = Treatment.new(treatment_params)

    respond_to do |format|
      if @treatment.save
        format.html { redirect_to @treatment, notice: 'Treatment was successfully created.' }
        format.json { render :show, status: :created, location: @treatment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @treatment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @treatment.update(treatment_params)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @treatment.destroy!

    respond_to do |format|
      format.html { redirect_to treatments_path, notice: 'Treatment was successfully destroyed.', status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def set_treatment
    @treatment = Treatment.find(params[:id])
  end

  def treatment_params
    params.require(:treatment).permit(:treated_on, :description)
  end
end
