class CreateEmployees < ActiveRecord::Migration[5.2]
  def change
    create_table :employees do |t|
      t.string :name
      t.integer :department_id
      t.boolean :admin
      t.string :title
      t.string :email
      t.string :address
      t.string :phone
      t.float :salary
      t.float :bonus
      t.boolean :health_insurance
      t.boolean :matching
      t.boolean :pto

      t.timestamps
    end
  end
end
