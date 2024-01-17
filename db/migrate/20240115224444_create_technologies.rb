class CreateTechnologies < ActiveRecord::Migration[6.1]
  def change
    create_table :technologies do |t|
      t.string :name
      t.timestamps
    end

    create_table :projects_technologies, id: false do |t|
      t.belongs_to :project
      t.belongs_to :technology
    end

    create_table :employees_technologies, id: false do |t|
      t.belongs_to :employee
      t.belongs_to :technology
    end
  end
end
