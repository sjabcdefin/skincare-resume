# frozen_string_literal: true

module ProgressBarHelper
  def skincare_steps
    {
      'products' => t('progress_bar.steps.product'),
      'medications' => t('progress_bar.steps.medication'),
      'allergies' => t('progress_bar.steps.allergy'),
      'treatments' => t('progress_bar.steps.treatment'),
      'skincare_resumes' => t('progress_bar.steps.confirmation')
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
