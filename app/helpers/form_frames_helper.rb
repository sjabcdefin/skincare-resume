# frozen_string_literal: true

module FormFramesHelper
  def form_frame_for(resource)
    resource.persisted? ? dom_id(resource) : 'new_form'
  end
end
