class CreateMedications < ActiveRecord::Migration[8.0]
  def change
    create_table :medications do |t|
      t.references :skincare_resume, null: false, foreign_key: true
      t.date :started_on
      t.string :name

      t.timestamps
    end
  end
end
