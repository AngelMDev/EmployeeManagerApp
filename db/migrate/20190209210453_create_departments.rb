class CreateDepartments < ActiveRecord::Migration[5.2]
  def change
    create_table :departments do |t|
      t.string :name
      t.references :company, foreign_key: true
      t.references :director, foreign_key: true
      t.string :location

      t.timestamps
    end
  end
end
