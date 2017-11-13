class CreateUserReports < ActiveRecord::Migration[5.1]
  def change
    create_table :user_reports do |t|
      t.integer :user_id
      t.integer :report_id
    end
  end
end
