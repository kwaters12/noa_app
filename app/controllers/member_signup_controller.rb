class MemberSignupController < ApplicationController
  include Wicked::Wizard

  steps :personal_info, :broker_type, :brokerage_info, :noa_application, :payment_info

  def show
    @broker = Broker.new
    render_wizard
  end
end
