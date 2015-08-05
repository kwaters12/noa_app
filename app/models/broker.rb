class Broker < User
  has_many :clients
  has_many :noa_applications
  belongs_to :sub_brokerage
  belongs_to :brokerage

  def brokerage_name
    brokerage.try(:name)
  end

  def brokerage_name=(brokerage_name)
    self.brokerage = Brokerage.find_or_create_by(name: brokerage_name) if brokerage_name.present?
  end

  def sub_brokerage_name
    sub_brokerage.try(:name)
  end

  def sub_brokerage_name=(sub_brokerage_name)
    self.sub_brokerage = SubBrokerage.find_or_create_by(name: sub_brokerage_name) if sub_brokerage_name.present?
  end
end