class NoaApplicationsController < ApplicationController
  protect_from_forgery except: [:hook]
  


  def index
    @noa_applications = NoaApplication.all

    respond_to do |format|
      format.html {render}
      format.json { render json: @noa_applications.all }
    end
  end

  def new 
    @noa_application = NoaApplication.find(params[:noa_application_id]) || NoaApplication.new
  end

  def create
    if user_signed_in?
      @broker = current_user
      # @client Client.find(params[:sin])
      if !@client
        @client = Client.new client_params
        configure_client(@client)
      end
      
      @client.broker_id = @broker.id
      @noa_application = @broker.noa_applications.new(document_params)
      @noa_application.client_id = @client.id
      if @noa_application.save
        #redirect_to root_url, notice: "Thank You!"
        redirect_to @noa_application.paypal_url(noa_application_path(@noa_application, :format => 'pdf'))
      else
        flash.now[:error] = "Sorry, your application was not saved"
        render :new
      end
    
    else
      @client = Client.new client_params
      @client.save
      

      @noa_application = @client.noa_applications.new(document_params)
      if @noa_application.save
        redirect_to root_url, notice: "Thank You!"
      else
        flash.now[:error] = "Sorry, your application was not saved"
        render :new
      end

    end
  end

  def edit
    @noa_application = NoaApplication.find(params[:id])
  end

  def update
    @noa_application = NoaApplication.find(params[:id])
    if @noa_application.update_attributes(document_params)
      handle_payment(params[:payment_method], @noa_application)
      # redirect_to @noa_application.paypal_url(noa_application_path(@noa_application))
      # redirect_to noa_application_path
    else
      render :edit
    end
  end

  def destroy
    @noa_application = NoaApplication.find(params[:id])
    if @noa_application.user = current_user
      @noa_application.destroy
      redirect_to noa_applications_path, notice: "Application Deleted Successfuly"
    else
      redirect_to noa_applications_path, notice: "Sorry, We Can Not Delete This Application"
    end
  end

  def show
    @noa_application = NoaApplication.find(params[:id])
    respond_to do |format|
      format.pdf { send_file TestPdfForm.new(@noa_application).export, type: 'application/pdf'}
      format.html { noa_application_path(@noa_application) }
    end
  end

  def hook
    params.permit!
    status = params[:payment_status]
    if status == "Completed" 
      @noa_application = NoaApplication.find params[:invoice]
      @noa_application.update_attributes notification_params: params, status: status, transaction_id: params[:txn_id], purchased_at: Time.now
    end
    render nothing: true
  end

  


  private

  def document_params
    params.require(:noa_application).permit([:broker_first_name, :broker_last_name, :brokerage_name, :brokerage_phone_number, :brokerage_email, :referral_first_name, :referral_last_name, :first_name, :last_name, :address, :city, :province, :postal_code, :phone_number, :email, :sin, :dob, :noa_selection, :has_signature, :status, :notification_params, :transaction_id, :purchased_at])
  end

  def client_params
    params.require(:client).permit([:first_name, :last_name, :sin, :dob, :email, :phone_number])   

  end

  def handle_payment(payment_method, noa_application)
    if payment_method === 'Paypal'
      redirect_to noa_application.paypal_url(noa_application_path(noa_application))
    else
      redirect_to noa_application_path(noa_application)
    end
  end

end
