# frozen_string_literal: true

module NavigationHelper
  def nav_button(label, path)
    if path.present?
      link_to label, path, class: 'w-24 rounded-md text-center px-3.5 py-2 bg-[#5F7F67] hover:bg-[#4A6652] text-white font-medium'
    else
      content_tag(:span, '', class: 'w-24')
    end
  end
end
