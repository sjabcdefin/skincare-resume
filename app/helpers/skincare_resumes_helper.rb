# frozen_string_literal: true

module SkincareResumesHelper
  def resume_save_button_text(status)
    if status == :draft
      t('buttons.save.draft_guest')
    elsif status == :completed
      current_user ? t('buttons.save.completed_login') : t('buttons.save.completed_guest')
    end
  end

  def resume_button_text(resume)
    resume.status == 'draft' ? t('buttons.edit.draft') : t('buttons.edit.completed')
  end

  def print_date(name, date)
    name ? format_date(date) : blank_cell
  end

  def print_name(name)
    name || blank_cell
  end

  def format_date(date)
    date ? l(date, format: :default) : t('common.date_blank')
  end

  def blank_cell
    content_tag(:span, '&nbsp;'.html_safe)
  end

  def resume_items_empty(resume)
    resume.products.empty? && resume.medications.empty? && resume.allergies.empty? && resume.treatments.empty?
  end

  def save_button_class(resume)
    resume.present? ? 'bg-[#5F7F67] hover:bg-[#4A6652] text-white' : 'bg-gray-300 text-gray-500 cursor-not-allowed'
  end
end
