class DownloadsController < ApplicationController
  def download
    if params[:id] == 'project'
      send_file Rails.root.join('public/downloads', 'project.pdf'), type: "application/pdf", x_sendfile: true
    elsif params[:id] == 'projects'
      send_file Rails.root.join('public/downloads', 'projects.csv'), type: "text/csv", x_sendfile: true
    end
  end
end
