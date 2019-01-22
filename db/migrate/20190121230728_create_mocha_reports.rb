class CreateMochaReports < ActiveRecord::Migration[5.2]
  def change
    create_table :mocha_reports do |t|
      t.integer :suites
      t.integer :total
      t.integer :passes
      t.integer :pending
      t.integer :failures
      t.integer :duration
      t.datetime :started
      t.datetime :ended
    end
  end
end
