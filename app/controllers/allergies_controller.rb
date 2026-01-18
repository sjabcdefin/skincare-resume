# frozen_string_literal: true

class AllergiesController < ApplicationController
  before_action :set_allergy, only: %i[show edit update destroy]

  def index
    @allergies = current_user ? all_for_login : all_for_guest
  end

  def show; end

  def new
    @allergy = Allergy.new
  end

  def edit; end

  def create
    @allergy = current_user ? build_for_login : build_for_guest

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

  def set_allergy
    @allergy = current_user ? find_for_login : find_for_guest
  end

  def allergy_params
    params.require(:allergy).permit(:name)
  end

  def find_for_login
    current_user.skincare_resume.allergies.find(params[:id])
  end

  def find_for_guest
    current_resume.allergies.find(params[:id])
  end

  def all_for_login
    resume = current_user&.skincare_resume
    resume ? resume.allergies : []
  end

  def all_for_guest
    current_resume ? current_resume.allergies : []
  end

  def build_for_login
    resume = current_user.skincare_resume
    resume ||= current_user.create_skincare_resume(status: :draft)
    resume.allergies.new(allergy_params)
  end

  def build_for_guest
    resume = current_resume
    resume ||= SkincareResume.create!(uuid: SecureRandom.uuid, status: :draft, user_id: nil)
    @session['resume_uuid'] = resume.uuid
    resume.allergies.new(allergy_params)
  end

  def current_resume
    @session = session
    return nil unless @session['resume_uuid']

    SkincareResume.find_by(uuid: @session['resume_uuid'])
  end
end
