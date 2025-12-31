# frozen_string_literal: true

class Product::GuestProductRepository
  def initialize(session:)
    @session = session
  end

  def find(id)
    attrs = session_products.find { |p| p['id'] == id }
    SessionProduct.new(attrs)
  end

  def all
    session_products
      .map { |attrs| SessionProduct.new(attrs) }
      .sort_by { |p| [p.started_on.nil? ? 0 : 1, p.started_on] }
  end

  def build(params)
    SessionProduct.new(params.to_h)
  end

  def save(product)
    product.persisted = true
    @session['resume_data'] ||= {}
    @session['resume_data']['products'] ||= []
    @session['resume_data']['products'] << product.attributes
  end

  def assign(product, params)
    attrs = find_session_product(product.id)
    SessionProduct.new(attrs.merge(params.to_h))
  end

  def update(product, params)
    attrs = find_session_product(product.id)
    attrs.merge!(params.to_h)
  end

  def destroy(product)
    @session['resume_data']['products'].reject! { |p| p['id'] == product.id }
  end

  private

  def session_products
    @session.dig('resume_data', 'products').to_a
  end

  def find_session_product(id)
    session_products.find { |p| p['id'] == id }
  end
end
