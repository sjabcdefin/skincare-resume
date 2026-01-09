class CreateSkincareResumes < ActiveRecord::Migration[8.0]
  def change
    create_table :skincare_resumes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :status
      t.string :uuid

      t.timestamps
    end
  end
end
