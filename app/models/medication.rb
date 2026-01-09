# frozen_string_literal: true

class Medication < ApplicationRecord
  belongs_to :skincare_resume
  validates :name, presence: true
end
