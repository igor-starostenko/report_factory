class RspecExceptions < ActiveRecord::Migration[5.1]
  def change
    create_table :rspec_exceptions do |t|
      t.belongs_to :rspec_example, index: true
      t.string :classname
      t.string :message
      t.text :backtrace, default: [].to_yaml
    end
  end
end
