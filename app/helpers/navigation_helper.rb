# frozen_string_literal: true

module NavigationHelper
  def nav_button(label, path)
    if path.present?
      link_to label, path, class: 'inline-flex items-center justify-center h-10 w-24 rounded bg-[#5F7F67] hover:bg-[#4A6652] text-sm font-normal text-white'
    else
      content_tag(:span, '', class: 'w-24')
    end
  end
end
