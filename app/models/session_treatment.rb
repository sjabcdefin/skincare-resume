# frozen_string_literal: true

class SessionTreatment
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :id, :string
  attribute :name, :string
  attribute :treated_on, :date
  attribute :persisted, :boolean, default: false

  validates :name, presence: true

  def initialize(attributes = {})
    super(attributes)
    self.id ||= SecureRandom.uuid
  end

  def self.model_name
    Treatment.model_name
  end

  def persisted?
    persisted
  end
end
