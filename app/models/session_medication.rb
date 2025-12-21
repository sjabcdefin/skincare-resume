# frozen_string_literal: true

class SessionMedication
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :id, :string
  attribute :name, :string
  attribute :started_on, :date
  attribute :persisted, :boolean, default: false

  validates :name, presence: true

  def initialize(attributes = {})
    super(attributes)
    self.id ||= SecureRandom.uuid
  end

  def self.model_name
    Medication.model_name
  end

  def persisted?
    persisted
  end
end
