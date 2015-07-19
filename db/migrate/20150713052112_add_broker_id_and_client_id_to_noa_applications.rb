class AddBrokerIdAndClientIdToNoaApplications < ActiveRecord::Migration
  def change
    add_reference :noa_applications, :broker, index: true
    add_foreign_key :noa_applications, :brokers
    add_reference :noa_applications, :client, index: true
    # add_foreign_key :noa_applications, :clients
  end
end
