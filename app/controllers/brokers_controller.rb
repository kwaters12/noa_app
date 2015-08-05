class BrokersController < ApplicationController

  def new 
    @broker = Broker.new
    @brokerages = Broker.all
  end

  def index 
    @broker = Broker.all
  end

  def create
    @broker = Broker.new broker_params

    if @broker.save
        respond_to do |format|
          format.html { redirect_to new_client_path }
          format.js
          format.json  { render json: @broker }   
        end 
        #redirect_to root_url, notice: "Thank You!"
        
      else
        flash.now[:error] = "Sorry, your application was not saved"
        render :new
      end
  end



  private

  def broker_params
    params.require(:broker).permit([:first_name, :last_name, :email, :phone_number, :broker_type, :brokerage_name, :sub_brokerage_name, :brokerage_id, :password, :password_confirmation])
  end
end
