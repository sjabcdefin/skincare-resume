class SkincareResumesController < ApplicationController
  before_action :set_skincare_resume, only: %i[ show edit update destroy ]

  # GET /skincare_resumes or /skincare_resumes.json
  def index
    @skincare_resumes = SkincareResume.all
  end

  # GET /skincare_resumes/1 or /skincare_resumes/1.json
  def show
  end

  # GET /skincare_resumes/new
  def new
    @skincare_resume = SkincareResume.new
  end

  # GET /skincare_resumes/1/edit
  def edit
  end

  # POST /skincare_resumes or /skincare_resumes.json
  def create
    @skincare_resume = SkincareResume.new(skincare_resume_params)

    respond_to do |format|
      if @skincare_resume.save
        format.html { redirect_to @skincare_resume, notice: "Skincare resume was successfully created." }
        format.json { render :show, status: :created, location: @skincare_resume }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @skincare_resume.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /skincare_resumes/1 or /skincare_resumes/1.json
  def update
    respond_to do |format|
      if @skincare_resume.update(skincare_resume_params)
        format.html { redirect_to @skincare_resume, notice: "Skincare resume was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @skincare_resume }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @skincare_resume.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /skincare_resumes/1 or /skincare_resumes/1.json
  def destroy
    @skincare_resume.destroy!

    respond_to do |format|
      format.html { redirect_to skincare_resumes_path, notice: "Skincare resume was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_skincare_resume
      @skincare_resume = SkincareResume.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def skincare_resume_params
      params.require(:skincare_resume).permit(:user_id, :status)
    end
end
