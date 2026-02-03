# frozen_string_literal: true

class AllergiesController < ApplicationController
  before_action :set_allergy, only: %i[show edit update destroy]

  def index
    @allergies = repository.all
  end

  def show; end

  def new
    @allergy = Allergy.new
  end

  def edit; end

  def create
    @allergy = repository.build(allergy_params)

    if @allergy.save
      flash.now.notice = 'アレルギー歴の登録に成功しました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @allergy.update(allergy_params)
      flash.now.notice = 'アレルギー歴の更新に成功しました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @allergy.destroy!
    flash.now.notice = 'アレルギー歴の削除に成功しました。'
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
