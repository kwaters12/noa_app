class ClientMailer < ApplicationMailer
  default from: 'notifications@noacanada.com'

  def dropbox_link(client, link)
    @client = client
    @link = link
    mail(to: @client.email, subject: 'Your NOA Shared Folder')
  end
end
