# frozen_string_literal: true

module SkincareResumesHelper
  def save_button_class(disabled)
    disabled ? 'bg-gray-300 text-gray-500 cursor-not-allowed' : 'bg-[#5F7F67] hover:bg-[#4A6652] text-white cursor-pointer'
  end
end
