class ChangeUserIdNullOnSkincareResumes < ActiveRecord::Migration[7.2]
  def change
    change_column_null :skincare_resumes, :user_id, true
  end
end
