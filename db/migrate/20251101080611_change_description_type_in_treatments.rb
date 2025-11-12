class ChangeDescriptionTypeInTreatments < ActiveRecord::Migration[7.2]
  def change
    change_column :treatments, :description, :string
  end
end
