# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @products = fetch_products
  end

  def show; end

  def new
    @product = Product.new
  end

  def edit; end

  def create
    @product = create_product
    flash.now.notice = t('.success')
  end

  def update
    update_product
    flash.now.notice = t('.success')
  end

  def destroy
    destroy_product
    flash.now.notice = t('.success')
  end

  private

  def product_params
    params.require(:product).permit(:started_on, :name)
  end

  def session_products
    session.dig('resume_data', 'products') || []
  end

  def set_product
    @product = current_user ? set_product_for_login : set_product_for_guest
  end

  def set_product_for_login
    Product.find(params[:id])
  end

  def set_product_for_guest
    attrs = session_products.find { |product| product['id'] == params[:id] }
    SessionProduct.new(attrs)
  end

  def fetch_products
    current_user ? fetch_products_for_login : fetch_products_for_guest
  end

  def fetch_products_for_login
    Product.all.order(:started_on)
  end

  def fetch_products_for_guest
    session_products
      .map { |attrs| SessionProduct.new(attrs) }
      .sort_by { |p| [p.started_on.nil? ? 0 : 1, p.started_on] }
  end

  def create_product
    current_user ? create_product_for_login : create_product_for_guest
  end

  def create_product_for_login
    resume = find_or_create_resume
    resume.products.create!(product_params)
  end

  def create_product_for_guest
    session['resume_data'] ||= {}
    session['resume_data']['products'] ||= []

    product = SessionProduct.new(product_params.to_h)
    session['resume_data']['products'] << product.attributes

    product
  end

  def find_or_create_resume
    current_user.skincare_resume || current_user.create_skincare_resume!(status: :draft)
  end

  def update_product
    current_user ? @product.update!(product_params) : update_product_for_guest
  end

  def update_product_for_guest
    attrs = session_products.find { |product| product['id'] == params[:id] }
    attrs.merge!(product_params.to_h)

    @product = SessionProduct.new(attrs)
  end

  def destroy_product
    current_user ? @product.destroy! : destroy_product_for_guest
  end

  def destroy_product_for_guest
    session['resume_data']['products'].reject! { |product| product['id'] == params[:id] }
  end
end
