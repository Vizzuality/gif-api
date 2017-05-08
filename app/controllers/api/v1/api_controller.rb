module Api
  module V1
    skip_before_action  :verify_authenticity_token
    class ApiController < ActionController::Base
      protect_from_forgery with: :null_session
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
      before_action :authenticate_request

      attr_reader :current_user
      helper_method :current_user

      private

        def authenticate_request
          @current_user = AuthenticateApiRequest.call(request.headers).result
          render json: { error: 'Not Authorized' }, status: 401 unless @current_user
        end

        def record_not_found
          render json: { errors: [{ status: '404', title: 'Record not found' }] } ,  status: 404
        end

    end
  end
end
