module Api::V1
  class ProjectsController < ApiController
    def index
      projects = Project.fetch_all(filter_params)
      render json: projects, each_serializer: ProjectSerializer
    end
    private
      def filter_params
        params.permit(:order, :direction)
      end
  end
end