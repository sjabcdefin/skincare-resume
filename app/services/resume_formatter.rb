# frozen_string_literal: true

class ResumeFormatter
  PRODUCTS_MAX_SIZE = 12
  MEDICATIONS_MAX_SIZE = 4
  ALLERGIES_MAX_SIZE = 4
  TREATMENTS_MAX_SIZE = 24

  DisplayRow = Struct.new(:name, :date, :over_limit, keyword_init: true)

  def initialize(resume:, mode:)
    @resume = resume
    @mode = mode
  end

  def product_rows
    products = @resume&.products || Product.none
    format(sort_and_limit(products, PRODUCTS_MAX_SIZE), PRODUCTS_MAX_SIZE) { Product.new }
  end

  def medication_rows
    medications = @resume&.medications || Medication.none
    format(sort_and_limit(medications, MEDICATIONS_MAX_SIZE), MEDICATIONS_MAX_SIZE) { Medication.new }
  end

  def allergy_rows
    allergies = @resume&.allergies || Allergy.none
    format(allergies, ALLERGIES_MAX_SIZE) { Allergy.new }
  end

  def treatment_rows
    treatments = @resume&.treatments || Treatment.none
    format(sort_and_limit(treatments, TREATMENTS_MAX_SIZE), TREATMENTS_MAX_SIZE) { Treatment.new }
  end

  private

  def sort_and_limit(records, max)
    return records.order_for_display if @mode == :display

    records.order_for_print.limit(max).reverse
  end

  def format(records, max, &block)
    over_limit_count = [records.size - max, 0].max
    padded_records = records.to_a + Array.new([max - records.size, 0].max, &block)

    padded_records.map.with_index do |record, index|
      DisplayRow.new(
        name: record.name,
        date: record.display_date,
        over_limit: index < over_limit_count
      )
    end
  end
end
