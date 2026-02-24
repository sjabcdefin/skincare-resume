# frozen_string_literal: true

class ProductsRepository < ResumeBasedRepository
  def all
    current_resume&.products || Product.none
  end

  def find(id)
    current_resume.products.find(id)
  end

  def build(params)
    writable_resume.products.build(params)
  end
end
