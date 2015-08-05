class BrokeragesController < ApplicationController

  def index
    @brokerages = Brokerage.order(:name).where("name LIKE ?", "%#{params[:term]}%")
    Rails.logger.info("&&&&&&&&&&&&&&&&&&&&&&&")
    Rails.logger.info(@brokerages.map(&:name))
    Rails.logger.info("&&&&&&&&&&&&&&&&&&&&&&&")
    render json: @brokerages.map(&:name)
  end

  def new 
    @brokerage = Brokerage.new
  end

  def create 
    @brokerage = Brokerage.new brokerage_params
    @brokerage.save
  end

  private

  def brokerage_params
    params.require(:brokerage).require([:name, :address, :city, :postal_code, :province, :phone_number])
  end

  # def autocomplete_brokerage_name
  #   brokerages = Brokerage.select([:name]).where("name LIKE ?", "%#{params[:name]}%")
  #   result = brokerages.collect do |t|
  #     { value t.name }
  #   end
  #   render json: result
  # end
end
