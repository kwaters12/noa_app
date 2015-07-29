class ClientsController < ApplicationController

  def index
    @clients = Client.all

    respond_to do |format|
      format.html {render}
      format.json { render json: @clients.all }
    end
  end

  def new 
    @client = Client.new
  end

  def create   
      @client = Client.new(client_params)
      @noa_application = @client.noa_applications.new(noa_application_params)
      @noa_application.client_id = @client.id

      if @client.save && @noa_application.save
        respond_to do |format|
          format.html { redirect_to noa_application_path(@noa_application), notice: "Thank You!" }
          format.js
          format.json  { render json: @client.to_json(include: @noa_application) }   
        end     
      else
        flash.now[:error] = "Sorry, your application was not saved"
        render :new
      end


    
  end

  def edit
    @client = Client.find(params[:id])
  end

  def update
    @client = Client.find(params[:id])
    if @client.update_attributes(client_params)
      redirect_to client_path
    else
      render :edit
    end
  end

  def destroy
    @client = Client.find(params[:id])
    if @client.user = current_user
      @client.destroy
      redirect_to clients_path, notice: "Application Deleted Successfuly"
    else
      redirect_to clients_path, notice: "Sorry, We Can Not Delete This Application"
    end
  end

  def show
    @client = Client.find(params[:id])
  end



  private

  def client_params
    params.require(:client).permit([:first_name, :last_name, :sin, :dob, :email, :phone_num, :broker_id])  
  end

  def noa_application_params
    params.require(:client).permit([:first_name, :last_name, :sin, :dob, :email, :phone_num, :broker_id, :client_id])  
  end

end
