class AddBrokerageIdSubBrokerageIdToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :brokerage, index: true
    add_foreign_key :users, :brokerages
    add_reference :users, :sub_brokerage, index: true
    add_foreign_key :users, :sub_brokerages
  end
end
