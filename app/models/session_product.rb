# frozen_string_literal: true

class SessionProduct
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :id, :string
  attribute :name, :string
  attribute :started_on, :date

  validates :name, presence: true

  def initialize(attributes = {})
    super(attributes)
    self.id ||= SecureRandom.uuid
  end

  def self.model_name
    Product.model_name
  end

  def persisted?
    id.present?
  end
end
