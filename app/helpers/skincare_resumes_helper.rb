# frozen_string_literal: true

module SkincareResumesHelper
  def resume_button_text(resume)
    resume.status == 'draft' ? '作成途中の履歴書を編集・更新する' : '作成した履歴書を編集・更新する'
  end

  def print_date(name, date)
    name ? format_date(date) : blank_cell
  end

  def print_name(name)
    name || blank_cell
  end

  def format_date(date)
    date ? l(date, format: :default) : '－'
  end

  def blank_cell
    content_tag(:span, '&nbsp;'.html_safe)
  end

  def resume_items_empty(resume)
    resume.products.empty? && resume.medications.empty? && resume.allergies.empty? && resume.treatments.empty?
  end
end
