# frozen_string_literal: true

class Treatment < ApplicationRecord
  validates :description, presence: true
  belongs_to :skincare_resume
end
