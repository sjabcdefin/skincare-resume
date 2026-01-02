# frozen_string_literal: true

class Product::LoginProductRepository
  def initialize(user:)
    @user = user
  end

  def find(id)
    @user.skincare_resume.products.find(id)
  end

  def all
    resume = @user.skincare_resume
    resume ? resume.products.order(:started_on) : []
  end

  def build(params)
    resume = @user.skincare_resume || @user.create_skincare_resume!(status: :draft)
    resume.products.build(params)
  end

  def save(product)
    product.save!
  end

  def assign(product, params)
    product.assign_attributes(params)
    product
  end

  def update(product, _params)
    product.save!
  end

  def destroy(product)
    product.destroy!
  end
end
