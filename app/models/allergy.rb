# frozen_string_literal: true

class Allergy < ApplicationRecord
  validates :name, presence: true
end
