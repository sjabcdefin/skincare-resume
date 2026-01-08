# frozen_string_literal: true

class TreatmentsController < ApplicationController
  before_action :set_repository
  before_action :set_treatment, only: %i[show edit update destroy]

  def index
    @treatments = @repository.all
  end

  def show; end

  def new
    @treatment = Treatment.new
  end

  def edit; end

  def create
    @treatment = @repository.build(treatment_params)

    if @treatment.save
      flash.now.notice = t('.success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @treatment.update(treatment_params)
      flash.now.notice = t('.success')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @treatment.destroy!
    flash.now.notice = t('.success')
  end

  private

  def set_repository
    @repository = if current_user
                    Treatment::LoginTreatmentRepository.new(user: current_user)
                  else
                    Treatment::GuestTreatmentRepository.new(session: session)
                  end
  end

  def set_treatment
    @treatment = @repository.find(params[:id])
  end

  def treatment_params
    params.require(:treatment).permit(:treated_on, :name)
  end
end
