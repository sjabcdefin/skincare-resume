# frozen_string_literal: true

class AllergiesController < ApplicationController
  before_action :set_repository
  before_action :set_allergy, only: %i[show edit update destroy]

  def index
    @allergies = @repository.all
  end

  def show; end

  def new
    @allergy = Allergy.new
  end

  def edit; end

  def create
    @allergy = @repository.build(allergy_params)
    return unless @allergy.valid?

    @repository.save(@allergy)
    flash.now.notice = t('.success')
  end

  def update
    @allergy = @repository.assign(@allergy, allergy_params)
    return unless @allergy.valid?

    @repository.update(@allergy, allergy_params)
    flash.now.notice = t('.success')
  end

  def destroy
    @repository.destroy(@allergy)
    flash.now.notice = t('.success')
  end

  private

  def set_repository
    @repository = if current_user
                    Allergy::LoginAllergyRepository.new(user: current_user)
                  else
                    Allergy::GuestAllergyRepository.new(session: session)
                  end
  end

  def set_allergy
    @allergy = @repository.find(params[:id])
  end

  def allergy_params
    params.require(:allergy).permit(:name)
  end
end
