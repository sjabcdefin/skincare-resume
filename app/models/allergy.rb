# frozen_string_literal: true

class Allergy < ApplicationRecord
  belongs_to :skincare_resume
  validates :name, presence: true

  scope :order_for_display, -> { order(id: :asc) }
  scope :order_for_print, -> { order(id: :desc) }

  def display_date
    nil
  end
end
