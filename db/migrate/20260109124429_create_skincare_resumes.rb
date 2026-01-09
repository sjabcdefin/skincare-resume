class CreateSkincareResumes < ActiveRecord::Migration[8.0]
  def change
    create_table :skincare_resumes do |t|
      t.references :user, foreign_key: { on_delete: :cascade }
      t.string :status
      t.string :uuid

      t.timestamps
    end
    add_index :skincare_resumes, :uuid, unique: true
  end
end
