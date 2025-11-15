class CreateMedications < ActiveRecord::Migration[7.2]
  def change
    create_table :medications do |t|
      t.date :started_on
      t.string :name

      t.timestamps
    end
  end
end
