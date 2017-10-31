class CreateRspecReports < ActiveRecord::Migration[5.1]
  def change
    create_table :rspec_reports do |t|
      t.string :version
      t.string :summary_line
    end
  end
end
