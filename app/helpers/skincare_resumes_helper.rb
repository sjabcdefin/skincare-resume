# frozen_string_literal: true

module SkincareResumesHelper
  def resume_button_text(resume)
    resume.status == 'draft' ? '作成途中の履歴書を編集・更新する' : '作成した履歴書を編集・更新する'
  end
end
