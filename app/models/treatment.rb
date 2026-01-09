# frozen_string_literal: true

class Treatment < ApplicationRecord
  belongs_to :skincare_resume
  validates :name, presence: true
end
