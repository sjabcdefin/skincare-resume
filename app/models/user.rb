class User < ApplicationRecord
  has_one :skincare_resume, inverse_of: :user, dependent: :destroy
end
