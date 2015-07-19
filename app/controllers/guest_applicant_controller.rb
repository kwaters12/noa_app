class GuestApplicantController < ApplicationController
  include Wicked::Wizard

  steps :personal_info, :noa_application, :form_signing, :payment_paypal, :payment_activemerchant

  def show
    case step
    when :personal_info
      @client = Client.new
    when :payment_paypal         
      redirect_to @noa_application.paypal_url(root_url) 
    when :payment_active_merchant  
      redirect_to @noa_application.activemerchant_url(root_url)  
    else
      @client = Client.find_or_create_by(email: params[:client][:email])
      render_wizard
    end
    
    @noa_application = @client.noa_applications.new 
    @client.save
             
    render_wizard
  end

  def update
    @client = Client.find_or_create_by(email: params[:client][:email])    
    @client.update_attributes(client_params)
    @client.save
    @noa_application = @client.noa_applications.new client_params
    
    render_wizard @client, params: params

    
  end

  private 

  def client_params
    params.require(:client).permit([:first_name, :last_name, :sin, :dob, :email, :phone_number])
  end

end
