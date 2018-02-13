module Api::V1
  class ProjectsController < ApiController
    before_action :get_project, only: [:show, :related]
    skip_before_action :authenticate_request, only: [:index, :show, :related, :get_project, :create]
    def index
      respond_to do |format|
        format.json do
          # rubocop:disable LineLength
          key_string = "projects#{request.url}_#{request.query_string}_#{Project.order('updated_at DESC').first.try(:updated_at)}_json".parameterize
          projects = Rails.cache.fetch(key_string) { render json: Project.fetch_all(filter_params), each_serializer: ProjectSerializer }
          # rubocop:enable LineLength
          render json: projects rescue projects
        end
        format.csv do
          # rubocop:disable LineLength
          key_string = "projects#{request.url}_#{request.query_string}_#{Project.order('updated_at DESC').first.try(:updated_at)}_csv".parameterize
          projects = Rails.cache.fetch(key_string) { Project.fetch_all(filter_params) }
          # rubocop:enable LineLength
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
        params.permit(:q, :summary, :order, :direction, :name, :from_cost, :to_cost, :offset, :limit, :other_organization, :other_donor, co_benefits:[], primary_benefits:[], status:[], scales:[], organizations:[], donors:[], countries:[], regions:[], hazard_types:[], intervention_types:[], nature_based_solutions:[])
      end
  end
end
