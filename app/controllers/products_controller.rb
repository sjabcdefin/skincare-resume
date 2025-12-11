# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @products = Product.all.order(:started_on)
  end

  def show; end

  def new
    @product = Product.new
  end

  def edit; end

  def create
    @product = resume.products.new(product_params)

    if @product.save
      flash.now.notice = t('.success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      flash.now.notice = t('.success')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy!
    flash.now.notice = t('.success')
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:started_on, :name)
  end

  def resume
    @resume = current_user.skincare_resume || current_user.create_skincare_resume(status: :draft)
  end
end
