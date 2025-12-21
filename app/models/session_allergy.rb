# frozen_string_literal: true

class SessionAllergy
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :id, :string
  attribute :name, :string
  attribute :persisted, :boolean, default: false

  validates :name, presence: true

  def initialize(attributes = {})
    super(attributes)
    self.id ||= SecureRandom.uuid
  end

  def self.model_name
    Allergy.model_name
  end

  def persisted?
    persisted
  end
end
