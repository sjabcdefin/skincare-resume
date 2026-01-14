# frozen_string_literal: true

module ProgressBarHelper
  def skincare_steps
    {
      'products' => 'スキンケア',
      'medications' => '薬名',
      'allergies' => 'アレルギー',
      'treatments' => '治療',
      'skincare_resumes' => '確認'
    }
  end

  def step_circle_class(step, current)
    if step == current
      'w-5 h-5 rounded-full bg-[#5F7F67] border-2 border-[#5F7F67] z-10'
    else
      'w-5 h-5 rounded-full bg-white border-2 border-[#5F7F67] z-10'
    end
  end
end
