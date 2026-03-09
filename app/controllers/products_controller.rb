# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @resume = repository.resume
    @products = repository.all.order_for_display
  end

  def show; end

  def new
    @product = Product.new
  end

  def edit; end

  def create
    @product = repository.build(product_params)
    @resume = repository.resume

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

  def repository
    @repository ||= ProductsRepository.new(
      user: current_user,
      session: session
    )
  end

  def set_product
    @product = repository.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:started_on, :name)
  end
end
