class CreateRspecExamples < ActiveRecord::Migration[5.1]
  def change
    create_table :rspec_examples do |t|
      t.belongs_to :rspec_report, index: true
      t.string :spec_id
      t.text :description
      t.text :full_description
      t.string :status
      t.string :file_path
      t.integer :line_number
      t.float :run_time
      t.string :pending_message
    end
  end
end
