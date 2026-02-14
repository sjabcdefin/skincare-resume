# frozen_string_literal: true

module SkincareResumesHelper
  def resume_button_text(resume)
    resume.status == 'draft' ? '作成途中の履歴書を編集・更新する' : '作成した履歴書を編集・更新する'
  end

  def display_date(date)
    date ? l(date, format: :default) : '－'
  end

  def blank_cell
    content_tag(:span, '&nbsp;'.html_safe)
  end
end
