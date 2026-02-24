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

    if @product.save
      flash.now.notice = 'スキンケア製品の登録に成功しました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      flash.now.notice = 'スキンケア製品の更新に成功しました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy!
    flash.now.notice = 'スキンケア製品の削除に成功しました。'
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
