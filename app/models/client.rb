class Client < ActiveRecord::Base
  has_many :noa_applications
  has_many :phone_numbers

  belongs_to :broker

  accepts_nested_attributes_for :noa_applications, :reject_if => :all_blank, :allow_destroy => true

end
