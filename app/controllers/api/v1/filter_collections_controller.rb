module Api::V1
  class FilterCollectionsController < ApiController
    skip_before_action :authenticate_request
    def index
      filters = FilterCollection.fetch_all
      render json: filters, root: true, status: 200
    end
  end
end
