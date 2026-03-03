# frozen_string_literal: true

class Allergy < ApplicationRecord
  belongs_to :skincare_resume
  validates :name, presence: true
  scope :order_for_display, -> {}
  scope :order_for_print, -> {}
end
