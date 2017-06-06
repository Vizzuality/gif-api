# == Schema Information
#
# Table name: projects
#
#  id                          :integer          not null, primary key
#  project_uid                 :integer
#  status                      :integer
#  name                        :text
#  scale                       :string
#  estimated_cost              :float
#  estimated_monetary_benefits :float
#  original_currency           :string
#  summary                     :text
#  start_year                  :integer
#  completion_year             :integer
#  implementation_status       :string
#  intervention_type           :string
#  learn_more                  :text
#  references                  :text
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  benefit_details             :text

#  IMPLEMENTATION_STATUSES = %w{pipeline ongoing completed}
#  INTERVENTION_TYPES = %w{hybrid green grey}
#  SCALES = %w{local regional national international}
#  enum status: [:under_revision, :published, :unpublished]
#  has_many :organizations_projects,dependent: :nullify
#  has_many :organizations, through: :organizations_projects,dependent: :nullify
#  has_many :donors_projects,dependent: :nullify
#  has_many :donors, through: :donors_projects,dependent: :nullify
#  has_and_belongs_to_many :primary_benefits_of_interventions,dependent: :nullify
#  has_and_belongs_to_many :co_benefits_of_interventions,dependent: :nullify
#  has_and_belongs_to_many :nature_based_solutions,dependent: :nullify
#  has_and_belongs_to_many :hazard_types,dependent: :nullify
#  has_and_belongs_to_many :locations,dependent: :nullify
ActiveAdmin.register Project do
  menu parent: "Projects admin", priority: 0
  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

  filter :project_uid
  filter :name
  filter :country,
    as: :select,
    collection: ->{ Location.joins(:projects).map{ |l| l.adm0_name }.uniq.sort_by(&:downcase) }
  filter :organization_tags,
    as: :select,
    collection: ->{ ActsAsTaggableOn::Tagging.includes(:tag).where(context: 'organizations').map{ |tagging| tagging.tag.name }.uniq.sort_by(&:downcase) }
  filter :donor_tags,
    as: :select,
    collection: ->{ ActsAsTaggableOn::Tagging.includes(:tag).where(context: 'donors').map{ |tagging| tagging.tag.name }.uniq.sort_by(&:downcase) }
  filter :tag_list,
    as: :select,
    collection: ->{ ActsAsTaggableOn::Tagging.includes(:tag).where(context: 'tags').map{ |tagging| tagging.tag.name }.uniq.sort_by(&:downcase) }
  filter :status, as: :select, collection: [:under_revision, :published, :unpublished]
  filter :organizations
  filter :donors
  filter :primary_benefits_of_interventions
  filter :co_benefits_of_interventions
  filter :nature_based_solutions
  filter :hazard_types
  filter :scale, as: :select, collection: Project::SCALES
  filter :implementation_status, as: :select, collection: Project::IMPLEMENTATION_STATUSES
  filter :intervention_type, as: :select, collection: Project::INTERVENTION_TYPES
  filter :estimated_cost
  filter :estimated_monetary_benefits
  filter :original_currency, as: :select
  filter :start_year
  filter :completion_year
  filter :created_at

  permit_params :name, :organization_list, :donor_list, :tag_list, :project_uid, :status, :scale, :estimated_cost, :estimated_monetary_benefits, :original_currency, :start_year, :completion_year, :implementation_status, :intervention_type, :summary, :learn_more, :references, :benefit_details, :location_codes, :other_nature_based_solution, :other_primary_benefits_of_intervention, :other_co_benefits_of_intervention, :picture,:remove_picture, :location_coordinates, organization_ids:[], donor_ids:[], primary_benefits_of_intervention_ids:[], co_benefits_of_intervention_ids:[], nature_based_solution_ids:[], hazard_type_ids:[]
  index do
    selectable_column
    column :id
    column :project_uid
    column :slug do |obj|
      obj.slug
    end
    column :name
    column :status
    column :organizations do |obj|
      obj.organizations.map{|a| a.name}.join(" | ")
    end
    actions
  end
  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :name, as: :string
      f.input :project_uid
      f.input :organization_list, as: :tags, multiple: :true, collection: ActsAsTaggableOn::Tagging.includes(:tag).where(context: 'organizations').map{ |tagging| tagging.tag.name }.uniq,
                input_html: {
                  value: f.object.organization_list.join(','),
                  data: { select_options: { tokenSeparators: [','] } }
                }
      f.input :donor_list, as: :tags, multiple: :true, collection: ActsAsTaggableOn::Tagging.includes(:tag).where(context: 'donors').map{ |tagging| tagging.tag.name }.uniq,
                input_html: {
                  value: f.object.donor_list.join(','),
                  data: { select_options: { tokenSeparators: [','] } }
                }
      f.input :tag_list, as: :tags, multiple: :true, collection: ActsAsTaggableOn::Tagging.includes(:tag).where(context: 'tags').map{ |tagging| tagging.tag.name }.uniq,
                input_html: {
                  value: f.object.tag_list.join(','),
                  data: { select_options: { tokenSeparators: [','] } }
                }
      f.input :status, as: :select, collection: %w{under_revision published unpublished}
      #f.input :location_codes, input_html: { value: object.current_location_codes }
      li do
        render partial: "admin/project/locations", locals: {coordinates: f.object.locations_projects.select(:latitude, :longitude).map{|l| {lat: l.latitude, ltd: l.longitude}}.to_json}
      end
      f.input :scale, as: :select, collection: Project::SCALES
      f.input :donors
      f.input :primary_benefits_of_interventions
      f.input :co_benefits_of_interventions
      f.input :nature_based_solutions
      f.input :hazard_types
      f.input :organizations
      f.input :estimated_cost
      f.input :estimated_monetary_benefits
      f.input :original_currency
      f.input :start_year
      f.input :completion_year
      f.input :implementation_status, collection: Project::IMPLEMENTATION_STATUSES
      f.input :intervention_type, as: :select, collection: Project::INTERVENTION_TYPES
      f.input :summary
      f.input :learn_more
      f.input :references
      f.input :benefit_details
      f.input :other_nature_based_solution
      f.input :other_primary_benefits_of_intervention
      f.input :other_co_benefits_of_intervention
      f.input :picture, as: :file, hint: (image_tag(f.object.picture.url(:thumb)) if f.object.picture.present?)
      f.input :remove_picture, as: :boolean, required: false, label: "remove picture"
    end
    f.actions
  end

end
