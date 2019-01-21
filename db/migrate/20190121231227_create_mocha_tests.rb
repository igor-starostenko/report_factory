class CreateMochaTests < ActiveRecord::Migration[5.2]
  def change
    create_table :mocha_tests do |t|
      t.belongs_to :mocha_report, index: true
      t.string :title
      t.string :full_title
      t.string :body
      t.integer :duration
      t.string :status
      t.string :speed
      t.string :file
      t.boolean :timed_out
      t.boolean :pending
      t.boolean :sync
      t.integer :async
      t.integer :current_retry
      t.string :err
    end
  end
end
