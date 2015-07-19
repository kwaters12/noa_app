class CreateBrokers < ActiveRecord::Migration
  def change
    create_table :brokers do |t|

      t.timestamps null: false
    end
  end
end
