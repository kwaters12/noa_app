class Brokerage < ActiveRecord::Base
  has_many :sub_brokerages
  has_many :brokers
end
