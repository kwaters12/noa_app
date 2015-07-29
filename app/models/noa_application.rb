require 'dropbox_sdk'
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

 

  def folder_name
    self.sin + ' ' + self.last_name + ', ' + self.first_name
  end

  def file_name
    self.sin + ' ' + self.last_name + ', ' + self.first_name + ' ' + Date.today.to_s +  '.pdf'
  end

  def move_pdf(pdf_path)
    @dropbox_client.put_file('/' + folder_name + '/' + file_name, open(pdf_path), overwrite=true)
  end

  def send_link
    find_client
    shareable = @dropbox_client.shares(folder_name + '/' + file_name)    
    ClientMailer.dropbox_link(@client, shareable['url']).deliver_now
  end

  def find_client
    @client = Client.find(self.client_id) 
  end

  

  

end