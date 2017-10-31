class CreateRspecSummaries < ActiveRecord::Migration[5.1]
  def change
    create_table :rspec_summaries do |t|
      t.belongs_to :rspec_report, index: true
      t.float :duration
      t.integer :example_count
      t.integer :failure_count
      t.integer :pending_count
      t.integer :errors_outside_of_examples_count
    end
  end
end
