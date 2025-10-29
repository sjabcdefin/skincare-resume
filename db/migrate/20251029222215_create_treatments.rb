class CreateTreatments < ActiveRecord::Migration[7.2]
  def change
    create_table :treatments do |t|
      t.date :treated_on
      t.text :description

      t.timestamps
    end
  end
end
