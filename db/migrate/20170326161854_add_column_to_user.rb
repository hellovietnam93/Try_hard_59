class AddColumnToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :telephone_number, :string
    add_column :users, :birthday, :datetime
  end
end
