class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up){ |u| u.permit(:broker_type, :sub_brokerage_id, :brokerage_id, :brokerage_name, :first_name, :last_name, :email, :phone_number, :password, :password_confirmation) } 
  end

end
