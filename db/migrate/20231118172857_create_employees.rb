class CreateEmployees < ActiveRecord::Migration[6.1]
  def change
    create_table :employees do |t|
      t.string :user_name
      t.references :project, foreign_key: true

      t.timestamps
    end


  end
end
