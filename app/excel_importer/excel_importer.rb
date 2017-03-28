require 'roo'

class ExcelImporter

  def initialize(file)
    @projects_excel_book = Roo::Spreadsheet.open(file, extension: :xlsx)
    @errors = []
  end

  attr_reader :errors

  EXCEL_HEADERS = ["PID", "Project Name", "Organization", "Main donor", "Scale", "Locations", "Hazard Type", "Intervention Type", "Nature-Based Solutions", "Estimated Cost (in millions)", "Estimated Monetary Benefits (in millions)", "Benefit details", "Original Currency", "Primary Benefits of Intervention", "Co-Benefits of Intervention", "Summary", "Start Year", "Completion Year (if applicable)", "Implementation Status URL", "URL (for further information)"]


  def import!
    @projects_excel_book.default_sheet = @projects_excel_book.sheets.first
    header = @projects_excel_book.first
    return unless valid_header?(header)
    blank_row = Hash[header.map{|column_name| [column_name, nil]}]
    previous_row = nil

    parsed_excel = @projects_excel_book.each_with_index.map do |row, i|
      next if i.zero? # first row is the header

      project_id = row[0]

      current_row = if project_id.present?
                      blank_row.clone
                    else
                      previous_row.clone
                    end

      row.each_with_index do |cell, j|
        current_row[header[j]] = cell if project_id.present? || cell.present?
      end

      previous_row = current_row
    end

    parsed_excel.each do |row|
      unless row.blank?
        row.each{ |k,v| v.strip! if v.is_a?(String) && !(v.equal? v) }
        begin
          project_data = DataExtractor.new(row)
          project_data.extract_project
          project_data.extract_organization if row['Organization'].present?
          project_data.extract_donor if row['Main donor'].present?
          @errors << project_data.errors.reject(&:blank?) if project_data.errors && !(project_data.errors.reject(&:blank?).blank?)
          Rails.logger.debug 'Project imported'
        rescue => e
          Rails.logger.debug e
          Rails.logger.debug e.backtrace.join("\n")
        end
      end
    end
  end

  def valid_header?(header)
    missing_fields = EXCEL_HEADERS - header
    unknown_fields = header - EXCEL_HEADERS
    if missing_fields == [] && unknown_fields == []
      return true
    else
      message = ''
      message += "missing fields: #{missing_fields}" if missing_fields != []
      message += " | unknown fields: #{unknown_fields}" if unknown_fields !=[]
      @errors = [[{ project: 0, errors: [{ format: "bad header #{message}" }] }]]
      return false
    end
  end

end
