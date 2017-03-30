ActiveAdmin.register_page "Excel Upload" do
  menu parent: "Administration", priority: 1


  controller do
    skip_before_action :verify_authenticity_token
    def index
      render 'admin/excel_upload/new', layout: 'active_admin'
    end
  end
   page_action :import, method: :post  do
      importer = ExcelImporter.new(params[:qqfile].tempfile.path)

      if importer.import!

        render json: {
          success: true,
          errors: importer.errors
        }

      else

        render json: {
          success: false,
          errors: importer.errors
        }

      end

    end
end
