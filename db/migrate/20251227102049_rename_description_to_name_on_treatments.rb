class RenameDescriptionToNameOnTreatments < ActiveRecord::Migration[7.2]
  def change
    rename_column :treatments, :description, :name
  end
end
