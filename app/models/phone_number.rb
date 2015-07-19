class PhoneNumber < ActiveRecord::Base
  belongs_to :broker
  belongs_to :client
end
