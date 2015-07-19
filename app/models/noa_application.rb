class NoaApplication < ActiveRecord::Base
  belongs_to :client
  belongs_to :broker

  after_save :generate_noa_application

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

  def generate_noa_application
    pdf_path = NoaApplicationPDFForm.new(self).export

    # @client = Dropbox::API::Client.new(:token  => ENV['DROPBOX_APP_KEY'], :secret => ENV['DROPBOX_APP_SECRET'])
    # # The file is a Dropbox::API::File object, so you can call methods on it!
    # @client.search('test.txt').each do |file|
    #   file.copy(file.path + ".old2")
    # end
  end

end