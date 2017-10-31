class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :project_name
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
