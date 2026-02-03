# frozen_string_literal: true

class MedicationsController < ApplicationController
  before_action :set_medication, only: %i[show edit update destroy]

  def index
    @medications = repository.all
  end

  def show; end

  def new
    @medication = Medication.new
  end

  def edit; end

  def create
    @medication = repository.build(medication_params)

    if @medication.save
      flash.now.notice = '薬の登録に成功しました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @medication.update(medication_params)
      flash.now.notice = '薬の更新に成功しました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @medication.destroy!
    flash.now.notice = '薬の削除に成功しました。'
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
