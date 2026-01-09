# frozen_string_literal: true

class Allergy < ApplicationRecord
  belongs_to :skincare_resume
  validates :name, presence: true
end
