# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]

  def index
    resume = current_user&.skincare_resume
    @products = resume ? resume.products.order(:started_on) : []
  end

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
      flash.now.notice = 'スキンケア製品の登録に成功しました。'
    else
      Rails.logger.info @product.errors.full_messages
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

  def set_product
    @product = current_user.skincare_resume.products.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:started_on, :name)
  end
end
