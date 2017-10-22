class CreateReports < ActiveRecord::Migration[5.1]
  def change
    create_table :reports do |t|
      t.string :version
      t.string :summary_line
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
