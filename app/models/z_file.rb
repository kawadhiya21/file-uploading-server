class ZFile < ActiveRecord::Base
  DIRECTORY = Dir.pwd + "/public/files"
  attr_accessor :tempfile
  belongs_to :user
  validates :user, :presence => true
  validates :name, :presence => true
  
  def save_file
    begin
      # Generate a random name for the file
      random_string = (0...15).map { (65 + rand(26)).chr }.join
      # Find the extension
      name_split = self.name.split('.')
      if name_split.length == 1
        ext = "txt"
      else
        ext = name_split[-1]
      end
      # create a new file name using random string and extension
      destination_name = random_string + "." + ext
      # save the file and move it to the directory
      path = File.join(DIRECTORY, destination_name)
      FileUtils.move self.tempfile, path
      self.file_hash = destination_name
      if self.save
        return true
      else
        return false
      end
    rescue
      return false
    end
  end

  def get_file_path
    File.join(DIRECTORY, self.file_hash)
  end
end
