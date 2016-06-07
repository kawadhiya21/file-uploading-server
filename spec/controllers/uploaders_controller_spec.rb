require 'rails_helper'

RSpec.describe UploadersController, type: :controller do
  describe "POST create" do
    before :each do
      FileUtils.touch(Dir.pwd + "/spec/fixtures/files/abc.pdf")
      path = File.join("files/abc.pdf")
      @file = fixture_file_upload(path)

      @user = User.new
      @user.name = "robinhood"
      @user.email = "rbhin@gmail.com"
      @user.password = "asdf1234"
      @user.password_confirmation = "asdf1234"
      @user.save
    end

    it "should upload a file when use is logged in" do
      session[:user_id] = @user.id
      post :create, :zfile => @file
      expect(flash[:message]).to eq("File saved successfully")
      expect(response).to redirect_to("/")
      zfiles = User.find(@user.id).z_files
      expect(zfiles[0][:name]).to eq("abc.pdf")
    end
  end

  describe "GET index" do
    before :each do
      FileUtils.touch(Dir.pwd + "/spec/fixtures/files/abc.pdf")
      path = File.join("files/abc.pdf")
      @file = fixture_file_upload(path)

      @user = User.new
      @user.name = "robinhood"
      @user.email = "rbhin@gmail.com"
      @user.password = "asdf1234"
      @user.password_confirmation = "asdf1234"
      @user.save
      
      2.times do |i|
        zfile = @user.z_files.new
        zfile.name = "abc.pdf"
        zfile.tempfile = Dir.pwd + "/spec/fixtures/files/abc.pdf"
        zfile.save_file
      end
    end
    
    it "should show the files uploaded" do
      session[:user_id] = @user.id
      get :index
      assigns(:files).each do |f|
        expect(f.name).to eq("abc.pdf")
      end
      expect(response).to render_template("index")
      expect(assigns.keys.include?("files")).to eq(true)
    end
  end

  describe "GET show" do
    render_views
    before :each do
      FileUtils.touch(Dir.pwd + "/spec/fixtures/files/abc.pdf")
      @user = User.new
      @user.name = "robinhood"
      @user.email = "rbhin@gmail.com"
      @user.password = "asdf1234"
      @user.password_confirmation = "asdf1234"
      @user.save

      @files = []
      2.times do |i|
        zfile = @user.z_files.new
        zfile.name = "abc.pdf"
        zfile.tempfile = Dir.pwd + "/spec/fixtures/files/abc.pdf"
        zfile.save_file
        @files << zfile.id
      end

      @admin = User.new
      @admin.name = "robinhood1"
      @admin.email = "rbhin1@gmail.com"
      @admin.password = "asdf1234"
      @admin.password_confirmation = "asdf1234"
      @admin.save
    end

    it "should allow to access the files of a user" do
      session[:user_id] = @user.id
      get :show, :id => @files[0]
      expect(response.headers["Content-Disposition"]).to eq("attachment; filename=\"abc.pdf\"")
    end

    it "should not allow to access files of other users" do
      session[:user_id] = @admin.id
      get :show, :id => @files[0]
      expect(response.body).to eq("You don't have access to this file")
    end

    it "should allow admin to access files of other users" do
      @admin.update_attribute(:role, "admin")
      session[:user_id] = @admin.id
      get :show, :id => @files[0]
      expect(response.headers["Content-Disposition"]).to eq("attachment; filename=\"abc.pdf\"") 
    end
  end 
end  
