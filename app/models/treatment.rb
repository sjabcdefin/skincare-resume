# frozen_string_literal: true

class Treatment < ApplicationRecord
  belongs_to :skincare_resume
  validates :name, presence: true
  scope :order_for_display, -> { order(arel_table[:treated_on].asc.nulls_first) }
end
