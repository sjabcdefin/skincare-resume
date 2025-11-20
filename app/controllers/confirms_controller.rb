# frozen_string_literal: true

class ConfirmsController < ApplicationController
  def show
    @products = Product.all.order(:started_on)
    @medications = Medication.all.order(:started_on)
    @allergies = Allergy.all
    @treatments = Treatment.all.order(:treated_on)
  end
end
