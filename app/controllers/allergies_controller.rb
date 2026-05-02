# frozen_string_literal: true

class AllergiesController < ApplicationController
  before_action :set_resume, only: %i[index create edit update destroy]
  before_action :set_allergy, only: %i[edit update destroy]

  def index
    @allergies = @resume&.allergies&.order_for_display || Allergy.none
  end

  def new
    @allergy = Allergy.new
  end

  def edit; end

  def create
    @resume ||= build_resume
    @allergy = @resume.allergies.build(allergy_params)

    if @allergy.save
      render :create
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @allergy.update(allergy_params)
      render :update
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @allergy.destroy!
    render :destroy
  end

  private

  def set_allergy
    raise ActiveRecord::RecordNotFound unless @resume

    @allergy = @resume.allergies.find(params[:id])
  end

  def allergy_params
    params.require(:allergy).permit(:name)
  end
end
