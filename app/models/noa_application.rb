class NoaApplication < ActiveRecord::Base
  belongs_to :client
  belongs_to :broker

  serialize :notification_params, Hash

  def paypal_url(return_path)
    values = {
        business: "kellywaters-facilitator@gmail.com",
        cmd: "_xclick",
        upload: 1,
        return: "#{Rails.application.secrets.app_host}#{return_path}",
        invoice: id,
        amount: 60,
        item_name: "NOA Application - Guest",
        item_number: 1,
        quantity: '1',
        notify_url: "#{Rails.application.secrets.app_host}/hook"
    }
    "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query
  end 

  def display_name
    display_name = first_name + ' ' + last_name
  end  

end