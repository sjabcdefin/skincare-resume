# frozen_string_literal: true

module NavigationHelper
  def nav_button(label, path)
    if path.present?
      link_to label,
              path,
              class: %w[
                inline-flex items-center justify-center
                h-10 w-24
                border border-[#5F7F67]
                rounded shadow-sm
                bg-white hover:bg-[#F3F7F4]
                text-sm text-[#5F7F67] font-medium
              ]
    else
      content_tag(:span, '', class: 'w-24')
    end
  end
end
