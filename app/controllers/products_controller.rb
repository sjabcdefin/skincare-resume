# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :set_resume, only: %i[index create edit update destroy]
  before_action :set_product, only: %i[edit update destroy]

  def index
    @products = @resume&.products&.order_for_display || Product.none
  end

  def new
    @product = Product.new
  end

  def edit; end

  def create
    @resume ||= build_resume
    @product = @resume.products.build(product_params)

    if @product.save
      render :create
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render :update
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy!
    render :destroy
  end

  private

  def set_product
    raise ActiveRecord::RecordNotFound unless @resume

    @product = @resume.products.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:started_on, :name)
  end
end
