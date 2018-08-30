module Api::V1
  class ContactsController < ApiController
    skip_before_action :authenticate_request
    def create
      if contact_params[:subject] && contact_params[:subject].present?
        render json: "email sent", status: 200  and return
      end
      contact = ContactMailer.new(contact_params[:email], contact_params[:name], contact_params[:message])
      contact.send
      render json: contact.response.to_json, status: contact.response.status_code
    end

    private
    def contact_params
      params.permit(:email, :name, :message, :subject, :contact)
    end
  end
end
