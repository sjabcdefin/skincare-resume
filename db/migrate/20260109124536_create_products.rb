class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.references :skincare_resume, null: false, foreign_key: { on_delete: :cascade }
      t.date :started_on
      t.string :name

      t.timestamps
    end
  end
end
