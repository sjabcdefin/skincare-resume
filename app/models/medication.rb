# frozen_string_literal: true

class Medication < ApplicationRecord
  validates :name, presence: true
  belongs_to :skincare_resume
end
