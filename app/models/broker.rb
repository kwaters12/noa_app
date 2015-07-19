class Broker < User
  has_many :clients
  has_many :noa_applications
  belongs_to :sub_brokerage
  belongs_to :brokerage
end