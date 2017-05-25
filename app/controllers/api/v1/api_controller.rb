module Api
  module V1
    class ApiController < ActionController::Base
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
      before_action :authenticate_request
      before_action :set_cors

      def set_cors
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
        headers['Access-Control-Request-Method'] = '*'
        headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
      end

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
