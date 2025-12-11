# frozen_string_literal: true

class AllergiesController < ApplicationController
  before_action :set_allergy, only: %i[show edit update destroy]

  def index
    @allergies = Allergy.all
  end

  def show; end

  def new
    @allergy = Allergy.new
  end

  def edit; end

  def create
    @allergy = resume.allergies.new(allergy_params)

    if @allergy.save
      flash.now.notice = t('.success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @allergy.update(allergy_params)
      flash.now.notice = t('.success')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @allergy.destroy!
    flash.now.notice = t('.success')
  end

  private

  def set_allergy
    @allergy = Allergy.find(params[:id])
  end

  def allergy_params
    params.require(:allergy).permit(:name)
  end

  def resume
    @resume = current_user.skincare_resume || current_user.create_skincare_resume(status: :draft)
  end
end
