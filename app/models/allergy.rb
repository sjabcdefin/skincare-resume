# frozen_string_literal: true

class Allergy < ApplicationRecord
  validates :name, presence: true
  belongs_to :skincare_resume
end
