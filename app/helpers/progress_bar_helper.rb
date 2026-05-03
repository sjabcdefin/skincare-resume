# frozen_string_literal: true

module ProgressBarHelper
  def skincare_steps
    {
      'products' => products_path,
      'medications' => medications_path,
      'allergies' => allergies_path,
      'treatments' => treatments_path,
      'confirmations' => skincare_resume_confirmation_path
    }
  end

  def step_circle_class(step, current)
    if step == current
      'mt-2 w-5 h-5 rounded-full bg-[#5F7F67] border-2 border-[#5F7F67] z-10'
    else
      'mt-2 w-5 h-5 rounded-full bg-white border-2 border-[#5F7F67] z-10'
    end
  end
end
