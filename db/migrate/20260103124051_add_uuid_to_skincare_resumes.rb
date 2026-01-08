class AddUuidToSkincareResumes < ActiveRecord::Migration[7.2]
  def change
    add_column :skincare_resumes, :uuid, :string
    add_index :skincare_resumes, :uuid, unique: true
  end
end
