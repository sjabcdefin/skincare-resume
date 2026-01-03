# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :set_repository
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @products = @repository.all
  end

  def show; end

  def new
    @product = Product.new
  end

  def edit; end

  def create
    @product = @repository.build(product_params)

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

  def set_repository
    @repository = if current_user
                    Product::LoginProductRepository.new(user: current_user)
                  else
                    Product::GuestProductRepository.new(session: session)
                  end
  end

  def set_product
    @product = @repository.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:started_on, :name)
  end
end
