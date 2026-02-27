# frozen_string_literal: true

class AllergiesController < ApplicationController
  before_action :set_allergy, only: %i[show edit update destroy]

  def index
    @resume = repository.resume
    @allergies = repository.all
  end

  def show; end

  def new
    @allergy = Allergy.new
  end

  def edit; end

  def create
    @allergy = repository.build(allergy_params)
    @resume = repository.resume

    if @allergy.save
      flash.now.notice = t('flash.create.success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @allergy.update(allergy_params)
      flash.now.notice = t('flash.update.success')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @allergy.destroy!
    flash.now.notice = t('flash.destroy.success')
  end

  private

  def repository
    @repository ||= AllergiesRepository.new(
      user: current_user,
      session: session
    )
  end

  def set_allergy
    @allergy = repository.find(params[:id])
  end

  def allergy_params
    params.require(:allergy).permit(:name)
  end
end
