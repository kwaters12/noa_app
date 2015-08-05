class AddTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :broker_type, :string
  end
end
