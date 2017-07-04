module Api::V1
  class ProjectsController < ApiController
    before_action :get_project, only: [:show, :related]
    skip_before_action :authenticate_request, only: [:index, :show, :related, :get_project, :create]
    def index
      projects = Project.fetch_all(filter_params)
      respond_to do |format|
        format.json do
          render json: projects, each_serializer: ProjectSerializer
        end
        format.csv do
          send_data projects.to_csv, filename: "users-#{Date.today}.csv"
        end
      end
    end
    def show
      render json: @project, serializer: ProjectSerializer
    end
    def related
      relateds = @project.related
      render json: relateds, each_serializer: ProjectSerializer
    end
    def get_project
      @project = Project.find_by_lug_or_id(params[:id])
    end
    def create
      project = ProjectFromApi.new(params[:project], current_user)
      project.create_or_update
      if project.errors.any?
        render json: project.errors, status: project.status
      else
        render json: project.result, serializer: ProjectSerializer
      end
    end
    private
      def filter_params
        params.permit(:q, :summary, :order, :direction, :name, :from_cost, :to_cost, :offset, :limit, co_benefits:[], primary_benefits:[], status:[], scales:[], organizations:[], donors:[], countries:[], regions:[], hazard_types:[], intervention_types:[], nature_based_solutions:[])
      end
  end
end
