# frozen_string_literal: true

class User < ApplicationRecord
  has_one :skincare_resume, inverse_of: :user, dependent: :destroy
  validates :email, presence: true, uniqueness: true
end
