# frozen_string_literal: true

module NavigationHelper
  def nav_button(label, path, direction:)
    return content_tag(:span, '', class: 'w-24') if path.blank?

    link_to path,
            class: %w[
              inline-flex items-center
              h-10 w-24
              border border-[#5F7F67]
              rounded shadow-sm
              bg-white hover:bg-[#F3F7F4] active:bg-[#E3EAE5]
              text-base text-[#5F7F67] font-medium
            ] do
      content_tag(:span, class: 'flex items-center w-full px-4') do
        safe_join(
          [
            content_tag(:span, arrow(direction, :left), class: 'text-left'),
            content_tag(:span, label, class: 'flex-1 text-center'),
            content_tag(:span, arrow(direction, :right), class: 'text-right')
          ]
        )
      end
    end
  end

  def arrow(direction, position)
    case [direction, position]
    when %i[previous left]
      t('buttons.navigation.previous_icon')
    when %i[next right]
      t('buttons.navigation.next_icon')
    else
      ''
    end
  end
end
