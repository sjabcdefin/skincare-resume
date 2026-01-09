class CreateAllergies < ActiveRecord::Migration[8.0]
  def change
    create_table :allergies do |t|
      t.references :skincare_resume, null: false, foreign_key: { on_delete: :cascade }
      t.string :name

      t.timestamps
    end
  end
end
