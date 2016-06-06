class UploadersController < ApplicationController
  before_filter :authenticated?

  def index
    @files = @current_user.z_files
  end

  def create
    zfile = params['zfile']
    @file = @current_user.z_files.new
    @file.name = zfile.original_filename
    @file.tempfile = zfile.tempfile
    if @file.save_file
      flash[:message] = "File saved successfully"
    else
      flash[:message] = "Could not save file due to some error"
    end
    redirect_to '/'
  end

  def show
    begin
      if admin?
        zfile = ZFile.find(params[:id])
      else
        zfile = @current_user.z_files.find(params[:id])
      end
      send_file(zfile.get_file_path, filename: zfile.name)
    rescue
      render plain: "You don't have access to this file"
    end
  end
end
