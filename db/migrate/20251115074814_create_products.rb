class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.date :started_on
      t.string :name

      t.timestamps
    end
  end
end
