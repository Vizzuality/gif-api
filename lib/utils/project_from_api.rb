# == Schema Information
#
# Table name: projects
#
#  id                                     :integer          not null, primary key
#  project_uid                            :integer
#  status                                 :integer
#  name                                   :text
#  scale                                  :string
#  estimated_cost                         :float
#  estimated_monetary_benefits            :float
#  original_currency                      :string
#  summary                                :text
#  start_year                             :integer
#  completion_year                        :integer
#  implementation_status                  :string
#  intervention_type                      :string
#  learn_more                             :text
#  references                             :text
#  created_at                             :datetime         not null
#  updated_at                             :datetime         not null
#  benefit_details                        :text
#  slug                                   :string
#  contributor_name                       :string
#  contributor_organization               :string
#  contact_info                           :text
#  other_nature_based_solution            :string
#  other_primary_benefits_of_intervention :string
#  other_co_benefits_of_intervention      :string
#  user_id                                :integer
#  benefits_currency                      :string
#  costs_usd                              :float
#  benefits_usd                           :float
#  picture_file_name                      :string
#  picture_content_type                   :string
#  picture_file_size                      :integer
#  picture_updated_at                     :datetime
# Relations:
# organizations
# donor
# primary_benefits_of_interventions
# co_benefits_of_interventions
# nature_based_solutions
# hazard_types
# locations
# constants:
# IMPLEMENTATION_STATUSES
# INTERVENTION_TYPES
# SCALES


class ProjectFromApi
  def initialize(data)
    @data = data
    @errors = []
    @project
  end

  attr_reader :errors, :data, :project, :status

  def create_or_update
    project = self.instantiate(data[:id])
    project.name = data[:name]
    project.estimated_monetary_benefits = data[:estimated_monetary_benefits]
    project.estimated_cost = data[:estimated_cost]
    project.original_currency = data[:currency_estimated_cost]
    project.benefits_currency = data[:currency_monetary_benefits]
    project.summary = data[:summary]
    project.start_year = data[:start_year]
    project.completion_year = data[:completion_year]
    project.implementation_status = data[:implementation_status]
    project.intervention_type = data[:intervention_type]
    project.learn_more = data[:learn_more]
    project.references = data[:references]
    project.benefit_details = data[:benefit_details]
    project.contributor_name = data[:contributor_name]
    project.contributor_organization = data[:contributor_organization]
    project.contact_info = data[:contact_info]
    if project.valid?
      project.save
      @status = 200
    else
      project.errors.full_messages.each do |error|
        @errors << {
          "status": "400",
          "title": "error",
          "detatil": error
        }
      end
      @status = 400
    end
  end

  def instantiate(id = nil)
    if data[:id].present?
      begin
        project = Project.find(data[:id])
      rescue ActiveRecord::RecordNotFound
        @errors <<  {
          "status": "404",
          "source": { "pointer": "/projects/#{data[:id]}" },
          "title":  "Not Found",
          "detail": "There is no project with id #{data[:id]}."
          }
        @status = 404
        return
      end
    else
      project = Project.new
    end
    project
  end

end