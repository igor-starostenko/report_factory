class AddRootUser < ActiveRecord::Migration[5.1]
  def change
    Admin.create!(name: 'Admin', email: 'admin@admin.com', password: 'Welcome1')
  end
end
