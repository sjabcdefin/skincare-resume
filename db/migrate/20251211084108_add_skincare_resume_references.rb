class AddSkincareResumeReferences < ActiveRecord::Migration[7.2]
  def change
    add_reference :products, :skincare_resume, null: false, foreign_key: true
    add_reference :medications, :skincare_resume, null: false, foreign_key: true
    add_reference :allergies, :skincare_resume, null: false, foreign_key: true
    add_reference :treatments, :skincare_resume, null: false, foreign_key: true
  end
end
