class OauthController < ApplicationController
  def authenticate_dropbox
    consumer = Dropbox::API::OAuth.consumer(:authorize)
   
    request_token = consumer.get_request_token
    # Store the token and secret so after redirecting we have the same request token
    session[:token] = request_token.token
    session[:token_secret] = request_token.secret
    request_token.authorize_url(:oauth_callback => 'http://localhost:3000/callback')
    # redirect_to request_token.authorize_url
    # Here the user goes to Dropbox, authorizes the app and is redirected
    # This would be typically run in a Rails controller
    hash = { oauth_token: session[:token], oauth_token_secret: session[:token_secret]}
    request_token  = OAuth::RequestToken.from_hash(consumer, hash)
    Rails.logger.info("%%%%%%%%%%%%%%%%%%")
    Rails.logger.info(request_token.inspect)
    Rails.logger.info("%%%%%%%%%%%%%%%%%%")

    oauth_token = "fOObVAMBomkAAAAAAAAAV38_HnMdOBK0ma2F7LgeL3_QQRLHNIirjFYUzeIhq9u8"

    # Rails.logger.info(request_token.get_access_token(:oauth_token => oauth_token).inspect)
    # result = request_token.get_access_token(:oauth_token => oauth_token)

    client = Dropbox::API::Client.new :token => request_token.params[:oauth_token], :secret => request_token.params[:oauth_token_secret]
    Rails.logger.info("%%%%%%%%%%%%%%%%")
    Rails.logger.info(ap client.account)
    Rails.logger.info("%%%%%%%%%%%%%%%%")
    client.mkdir 'new_dir'
    redirect_to root_url
  end
end