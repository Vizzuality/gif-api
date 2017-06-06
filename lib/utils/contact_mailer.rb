class ContactMailer

  require 'sendgrid-ruby'
  include SendGrid

  def initialize(sender_email, sender_name, message)
    @sender_email = sender_email
    @sender_name = sender_name
    @message = "
        Message from: #{@sender_name} \n
        Email: #{@sender_email} \n
        Message: #{message}
    "
    @response
  end

  attr_reader :sender, :message, :response

  def send
    from = Email.new(email: @sender_email)
    to = Email.new(email: ENV['CONTACT_EMAIL'])
    subject = 'New message from The Nature of Risk Reduction'
    content = Content.new(type: 'text/plain', value: @message)
    mail = Mail.new(from, subject, to, content)
    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    @response = sg.client.mail._('send').post(request_body: mail.to_json)
  end

end