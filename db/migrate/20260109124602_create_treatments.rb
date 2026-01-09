class CreateTreatments < ActiveRecord::Migration[8.0]
  def change
    create_table :treatments do |t|
      t.references :skincare_resume, null: false, foreign_key: true
      t.date :treated_on
      t.string :name

      t.timestamps
    end
  end
end
