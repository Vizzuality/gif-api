module Api::V1
  class ProjectsController < ApiController
    def index
      projects = Project.fetch_all(filter_params)
      render json: projects, each_serializer: ProjectSerializer
    end
    def show
      project = Project.find_by_lug_or_id(params[:id])
      render json: project, serializer: ProjectSerializer
    end
    private
      def filter_params
        params.permit(:q, :summary, :order, :direction, :name, :from_cost, :to_cost, :offset, :limit, co_benefits:[], primary_benefits:[], status:[], scales:[], organizations:[], donors:[], countries:[], regions:[], hazard_types:[], intervention_types:[], nature_based_solutions:[])
      end
  end
end
