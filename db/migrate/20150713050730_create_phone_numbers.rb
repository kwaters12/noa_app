class CreatePhoneNumbers < ActiveRecord::Migration
  def change
    create_table :phone_numbers do |t|
      t.references :broker, index: true
      t.references :client, index: true
      t.string :phone_number
      t.string :type

      t.timestamps null: false
    end
    # add_foreign_key :phone_numbers, :brokers
    # add_foreign_key :phone_numbers, :clients
  end
end
