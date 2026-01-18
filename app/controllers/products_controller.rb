# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @products = current_user ? all_for_login : all_for_guest
  end

  def show; end

  def new
    @product = Product.new
  end

  def edit; end

  def create
    @product = current_user ? build_for_login : build_for_guest

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

  def set_product
    @product = current_user ? find_for_login : find_for_guest
  end

  def product_params
    params.require(:product).permit(:started_on, :name)
  end

  def find_for_login
    current_user.skincare_resume.products.find(params[:id])
  end

  def find_for_guest
    current_resume.products.find(params[:id])
  end

  def all_for_login
    resume = current_user&.skincare_resume
    resume ? resume.products.order(:started_on) : []
  end

  def all_for_guest
    current_resume ? current_resume.products.order(:started_on) : []
  end

  def build_for_login
    resume = current_user.skincare_resume
    resume ||= current_user.create_skincare_resume(status: :draft)
    resume.products.build(product_params)
  end

  def build_for_guest
    resume = current_resume
    resume ||= SkincareResume.create!(uuid: SecureRandom.uuid, status: :draft, user_id: nil)
    @session['resume_uuid'] = resume.uuid
    resume.products.build(product_params)
  end

  def current_resume
    @session = session
    return nil unless @session['resume_uuid']

    SkincareResume.find_by(uuid: @session['resume_uuid'])
  end
end
