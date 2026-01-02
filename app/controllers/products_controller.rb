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
    return unless @product.valid?

    @repository.save(@product)
    flash.now.notice = t('.success')
  end

  def update
    @product = @repository.assign(@product, product_params)
    return unless @product.valid?

    @repository.update(@product, product_params)
    flash.now.notice = t('.success')
  end

  def destroy
    @repository.destroy(@product)
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
