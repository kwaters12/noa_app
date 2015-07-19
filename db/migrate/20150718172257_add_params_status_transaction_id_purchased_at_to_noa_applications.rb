class AddParamsStatusTransactionIdPurchasedAtToNoaApplications < ActiveRecord::Migration
  def change
    add_column :noa_applications, :notification_params, :text
    add_column :noa_applications, :status, :string
    add_column :noa_applications, :purchased_at, :datetime
    add_column :noa_applications, :transaction_id, :string
  end
end
