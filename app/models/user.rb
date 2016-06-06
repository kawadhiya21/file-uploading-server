require 'digest/md5'

class User < ActiveRecord::Base
  EMAIL_REGEX = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i
  validates :name, :presence => true, :length => { :in => 4..20 }
  validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX
  validates :password, :confirmation => true, :length => { :in => 6..30 }
  
  before_save :create_hashed_password, :default_values
  
  has_many :z_files
  
  private
  def create_hashed_password
    self.password = Digest::MD5.hexdigest(self.password)
  end

  def default_values
    self.role ||= 'user'
  end
  
  public
  def authenticate
    user = User.find_by_email(self.email)
    if user && user.password == create_hashed_password
      return user
    else
      return false
    end
  end

end
