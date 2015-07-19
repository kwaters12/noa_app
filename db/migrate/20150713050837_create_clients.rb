class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :first_name
      t.string :last_name
      t.string :sin
      t.string :dob
      t.string :email
      t.string :phone_num
      t.references :broker, index: true

      t.timestamps null: false
    end
    # add_foreign_key :clients, :brokers
  end
end
