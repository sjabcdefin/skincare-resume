class Medication < ApplicationRecord
  belongs_to :skincare_resume
  validates :name, presence: true
end
