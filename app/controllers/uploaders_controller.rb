class UploadersController < ApplicationController
  def index
    @files = ZFile.all
  end

  def create
    zfile = params['zfile']
    directory = "/Users/Kshitij/projects/megaupload/public/files"
    random_string = (0...15).map { (65 + rand(26)).chr }.join
    name_split = zfile.original_filename.split('.')
    if name_split.length == 1
      ext = "txt"
    else
      ext = name_split[-1]
    end
    destination_name = random_string + "." + ext
    path = File.join(directory, destination_name)
    FileUtils.move zfile.tempfile, path
    @file = ZFile.new
    @file.name = zfile.original_filename
    @file.file_hash = destination_name
    @file.save
    redirect_to '/'
  end

  def show
    zfile = ZFile.find(params[:id])
    directory = "/Users/Kshitij/projects/megaupload/public/files"
    path = File.join(directory, zfile.file_hash)
    send_file(path, filename: zfile.name)
  end
end
