class AddSubBrokerIdNameEmailPhoneNumAndBrokerTypeToBrokers < ActiveRecord::Migration
  def change
    add_column :brokers, :broker_type, :string
    add_reference :brokers, :sub_brokerage, index: true
    # add_foreign_key :brokers, :sub_brokerages
    add_reference :brokers, :brokerage, index: true
    # add_foreign_key :brokers, :brokerage
  end
end
