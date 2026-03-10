class RemoveStatusFromSkincareResumes < ActiveRecord::Migration[8.0]
  def change
    remove_column :skincare_resumes, :status, :string
  end
end
