# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]

  def index
    resume = current_user&.skincare_resume
    @products = resume ? resume.products.order(:started_on) : []
  end

  # GET /products/1 or /products/1.json
  def show; end

  def new
    @product = Product.new
  end

  def edit; end

  def create
    resume = current_user.skincare_resume
    resume ||= current_user.create_skincare_resume(status: :draft)
    @product = resume.products.new(product_params)

    if @product.save
      Rails.logger.info 'スキンケア製品の登録に成功しました。'
    else
      Rails.logger.info @product.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.', status: :see_other }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy!

    respond_to do |format|
      format.html { redirect_to products_path, notice: 'Product was successfully destroyed.', status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def set_product
    @product = current_user.skincare_resume.products.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:started_on, :name)
  end
end
