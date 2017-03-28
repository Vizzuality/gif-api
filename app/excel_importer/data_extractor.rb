class DataExtractor

  def initialize(row)
    @row = row
    @errors = []
    @project_index = row['PID']
  end

  attr_reader :errors, :row, :project_index

  def extract_project
    # Imports project
    project_attributes = row
    return if project_attributes.values.compact.blank? || project_index.blank?
    project = ProjectImporter.new(project_index, project_attributes)
    unless project.import!
      @errors << { project: project_index.to_i, errors: project.errors.compact }
      return false
    end
  end
end
