class SkincareResume < ApplicationRecord
  belongs_to :user, inverse_of: :skincare_resume, optional: true
  has_many :products, dependent: :destroy
  has_many :allergies, dependent: :destroy
  has_many :medications, dependent: :destroy
  has_many :treatments, dependent: :destroy
end
