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
      @client = Client.find(params[:client_id])
      if !@client
        @client = Client.new client_params
        configure_client(@client)
      end
      
      @client.broker_id = @broker.id
      @noa_application = @broker.noa_applications.new(document_params)
      if @noa_application.save

        # generate_noa_application(@noa_application)
        respond_to do |format|
          format.html { redirect_to @noa_application.paypal_url(noa_application_path(@noa_application, :format => 'pdf')) }
          format.js
          format.json  { render json: @client.to_json(include: @noa_application) }   
        end 
        #redirect_to root_url, notice: "Thank You!"
        
      else
        flash.now[:error] = "Sorry, your application was not saved"
        render :new
      end
    
    else
      @client = Client.new client_params
      @client.save
      @noa_application = @client.noa_applications.new(document_params)
      if @noa_application.save       
        # generate_noa_application(@noa_application)
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
    @client = Client.find(@noa_application.client_id)
    respond_to do |format|
      # format.pdf { send_file NoaApplicationPDFForm.new(@noa_application).export, type: 'application/pdf'}
      format.html { noa_application_path(@noa_application) }
      format.json { render json: @client.to_json(include: @noa_application) } 
    end

    if @noa_application.docusign_url.nil?
      attach_docusign_signature(@noa_application)
    else
      @url = @noa_application.docusign_url
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

  def docusign_response
    utility = DocusignRest::Utility.new
   
    if params[:event] == "signing_complete"
      get_document(params[:envelopeID])
      flash[:notice] = "Thanks! Successfully signed"
      render :text => utility.breakout_path(root_url), content_type: 'text/html'
    else
      get_document(params[:envelopeID])
      flash[:notice] = "You chose not to sign the document."
      render :text => utility.breakout_path(root_url), content_type: 'text/html'
    end
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

  def attach_docusign_signature(noa_application)
    @docusign = DocusignRest::Client.new
    output_path = noa_application.pdf_path
    
    document_envelope_response = @docusign.create_envelope_from_document(
      email: {
        subject: "test email subject",
        body: "this is the email body and it's large!"
      },
      # If embedded is set to true  in the signers array below, emails
      # don't go out to the signers and you can embed the signature page in an 
      # iFrame by using the client.get_recipient_view method
      signers: [
        {
          embedded: true,
          name: noa_application.display_name,
          email: noa_application.email,
          role_name: 'noa_application',
          sign_here_tabs: [
            {
              anchor_string: 'Print name of taxpayer',
              anchor_x_offset: '140',
              anchor_y_offset: '8'
            },
            {
              anchor_string: 'Signature of taxpayer',
              anchor_x_offset: '140',
              anchor_y_offset: '80'
            }
          ]
        }
      ],
      files: [
        {path: output_path, name: 'noa_application_pdf_form.pdf'},
      ],
      status: 'sent'
    )

    
    
    # @docusign.get_document_from_envelope(
    #   envelope_id: document_envelope_response["envelopeId"],
    #   document_id: 1,
    #   local_save_path: "#{Rails.root}/tmp/pdfs/#{SecureRandom.uuid}.pdf"
    # )


    @url = @docusign.get_recipient_view(
      envelope_id: document_envelope_response["envelopeId"],
      name: noa_application.display_name,
      email: noa_application.email,
      return_url: "http://localhost:3000/docusign_response/envelopeID=" + document_envelope_response["envelopeId"]
    )
    @url.each do |key, value|
      noa_application.docusign_url = value
    end
    
    noa_application.save

    File.delete(output_path)

    return @url
  end

  def get_document(envelope)
    require "net/http"
    require "uri"

    client = DocusignRest::Client.new
    Rails.logger.info("$$$$$$$$$$$$$$$$$$$$")
    Rails.logger.info(client.inspect)
    Rails.logger.info("$$$$$$$$$$$$$$$$$$$$")


    uri = URI.parse("http://" + client.endpoint + "/restapi/" + client.api_version + "/accounts/" + client.account_id + "/envelopes/" + envelope + "/documents/combined")

    # Shortcut
    response = Net::HTTP.get_response(uri)

    # Will print response.body
    Net::HTTP.get_print(uri)

    # Full
    http = Net::HTTP.new(uri.host, uri.port)
    response = http.request(Net::HTTP::Get.new(uri.request_uri))
    
    # random = "#{Rails.root}/tmp/pdfs/#{SecureRandom.uuid}.pdf"
    # client.get_document_from_envelope(
    #   envelope_id: envelope,
    #   document_id: 1,
    #   local_save_path: "#{Rails.root}/tmp/pdfs/#{SecureRandom.uuid}.pdf"
    # )
    
  end
  

end
