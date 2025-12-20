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
    @product = build_product
    return unless @product.valid?

    save_product
    flash.now.notice = t('.success')
  end

  def update
    assign_product_params
    return unless @product.valid?

    save_updated_product
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

  def build_product
    current_user ? build_product_for_login : build_product_for_guest
  end

  def build_product_for_login
    resume = find_or_create_resume
    resume.products.build(product_params)
  end

  def build_product_for_guest
    SessionProduct.new(product_params.to_h)
  end

  def find_or_create_resume
    current_user.skincare_resume || current_user.create_skincare_resume!(status: :draft)
  end

  def save_product
    current_user ? save_product_for_login : save_product_for_guest
  end

  def save_product_for_login
    @product.save!
  end

  def save_product_for_guest
    @product.persisted = true
    session['resume_data'] ||= {}
    session['resume_data']['products'] ||= []
    session['resume_data']['products'] << @product.attributes
  end

  def assign_product_params
    current_user ? assign_product_params_for_login : assign_product_params_for_guest
  end

  def assign_product_params_for_login
    @product.assign_attributes(product_params)
  end

  def assign_product_params_for_guest
    attrs = find_session_product
    new_attrs = attrs.merge(product_params.to_h)

    @product = SessionProduct.new(new_attrs)
  end

  def save_updated_product
    current_user ? save_product_for_login : save_updated_product_for_guest
  end

  def save_updated_product_for_guest
    attrs = find_session_product
    attrs.merge!(product_params.to_h)
  end

  def find_session_product
    session_products.find { |product| product['id'] == params[:id] }
  end

  def destroy_product
    current_user ? @product.destroy! : destroy_product_for_guest
  end

  def destroy_product_for_guest
    session['resume_data']['products'].reject! { |product| product['id'] == params[:id] }
  end
end
