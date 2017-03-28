module Api::V1
  class ProjectsController < ApiController
    def index
      projects = Project.fetch_all(filter_params)
      render json: projects, each_serializer: ProjectSerializer
    end
    private
      def filter_params
        params.permit(:order, :direction, :name, :from_cost, :to_cost, :offset, :limit, scales:[], organizations:[], donors:[], countries:[], regions:[], hazard_types:[], intervention_types:[], nature_based_solutions:[])
      end
  end
end
