class SubBrokerage < ActiveRecord::Base
  has_many :brokers

  belongs_to :brokerage
end
