module Api::V1
  class FilterCollectionsController < ApiController
    def index
      filters = FilterCollection.fetch_all
      render json: filters, root: true, status: 200
    end
  end
end
