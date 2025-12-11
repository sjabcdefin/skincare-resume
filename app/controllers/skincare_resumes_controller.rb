# frozen_string_literal: true

class SkincareResumesController < ApplicationController
  before_action :set_skincare_resume, only: %i[show edit update destroy]

  def index
    @skincare_resumes = SkincareResume.all
  end

  def show; end

  def new
    @skincare_resume = SkincareResume.new
  end

  def edit; end

  def create
    @skincare_resume = SkincareResume.new(skincare_resume_params)

    respond_to do |format|
      if @skincare_resume.save
        format.html { redirect_to @skincare_resume, notice: 'Skincare resume was successfully created.' }
        format.json { render :show, status: :created, location: @skincare_resume }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @skincare_resume.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @skincare_resume.update(skincare_resume_params)
      redirect_to '/confirmation', notice: t('.success')
    else
      render '/confirmation', status: :unprocessable_entity
    end
  end

  def destroy
    @skincare_resume.destroy!

    respond_to do |format|
      format.html { redirect_to skincare_resumes_path, notice: 'Skincare resume was successfully destroyed.', status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def set_skincare_resume
    @skincare_resume = SkincareResume.find(params[:id])
  end

  def skincare_resume_params
    params.require(:skincare_resume).permit(:user_id, :status)
  end
end
