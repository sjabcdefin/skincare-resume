# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :skincare_resume, touch: true
  validates :name, presence: true

  scope :order_for_display, -> {
    order(
      arel_table[:started_on].asc.nulls_first,
      arel_table[:id].asc
    )
  }
  scope :order_for_print, -> {
    order(
      arel_table[:started_on].desc.nulls_last,
      arel_table[:id].desc
    )
  }

  def display_date
    started_on
  end
end
