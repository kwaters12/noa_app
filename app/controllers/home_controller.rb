class HomeController < ApplicationController

  def index

    if @user = current_user
      # respond_to do |format|
      #   format.pdf { send_file TestPdfForm.new(@user).export, type: 'application/pdf' }
      # end
    end
  end
end
