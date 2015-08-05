class ClientsController < ApplicationController
  before_action :find_client, except: [:index, :new, :create]
  require 'dropbox_sdk'
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
        format.html { 
          generate_noa_application(@client, @noa_application)
          redirect_to noa_application_path(@noa_application), notice: "Thank You!" 
        }
        format.js
        format.json  { render json: @client.to_json(include: @noa_application) }   
      end     
    else
      flash.now[:error] = "Sorry, your application was not saved"
      render :new
    end    
  end

  def edit
    # @client = Client.find(params[:id])
  end

  def update
    # @client = Client.find(params[:id])
    if @client.update_attributes(client_params)
      redirect_to client_path
    else
      render :edit
    end
  end

  def destroy
    # @client = Client.find(params[:id])
    if @client.user = current_user
      @client.destroy
      redirect_to clients_path, notice: "Application Deleted Successfuly"
    else
      redirect_to clients_path, notice: "Sorry, We Can Not Delete This Application"
    end
  end

  def show
    # @client = Client.find(params[:id])
  end



  private

  def client_params
    params.require(:client).permit([:first_name, :last_name, :sin, :dob, :email, :phone_num, :broker_id])  
  end

  def noa_application_params
    params.require(:client).permit([:first_name, :last_name, :sin, :dob, :email, :phone_num, :broker_id, :client_id])  
  end

  def generate_noa_application(client, noa_application)
    noa_application.pdf_path = client.pdf_path = pdf_path = NoaApplicationPDFForm.new(noa_application).export

    Rails.logger.info("#*******************")
    Rails.logger.info(noa_application.pdf_path)
    Rails.logger.info("#*******************")
    @dropbox_client = DropboxClient.new('fOObVAMBomkAAAAAAAAAWHCIPbIWTv7bwD3nHivV2EXLwV0WgKCJRYK9ykrWo8Ru')

    folder = @dropbox_client.search('/', folder_name)
    if folder
      move_pdf(pdf_path)
      send_link
    else
      @dropbox_client.file_create_folder(folder_name)

      move_pdf(pdf_path)
      send_link
   
    end
    noa_application.save
    client.save

   
    
  end

  def folder_name
    @client.sin + ' ' + @client.last_name + ', ' + @client.first_name
  end

  def file_name
    @client.sin + ' ' + @client.last_name + ', ' + @client.first_name + ' ' + Date.today.to_s +  '.pdf'
  end

  def move_pdf(pdf_path)
    @dropbox_client.put_file('/' + folder_name + '/' + file_name, open(pdf_path), overwrite=true)
  end

  def send_link
    shareable = @dropbox_client.shares(folder_name + '/' + file_name)    
    ClientMailer.dropbox_link(@client, shareable['url']).deliver_now
  end

end
