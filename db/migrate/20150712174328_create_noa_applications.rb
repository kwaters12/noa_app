class CreateNoaApplications < ActiveRecord::Migration
  def change
    create_table :noa_applications do |t|
      t.string :broker_first_name
      t.string :broker_last_name
      t.string :brokerage_name
      t.string :brokerage_phone_number
      t.string :brokerage_email
      t.string :referral_first_name
      t.string :referral_last_name
      t.string :first_name
      t.string :last_name
      t.string :address
      t.string :city
      t.string :province
      t.string :postal_code
      t.string :phone_num
      t.string :email
      t.string :sin
      t.string :dob
      t.string :noa_selection
      t.boolean :has_signature
      t.boolean :is_paid

      t.timestamps null: false
    end
  end
end
