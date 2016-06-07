require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET signup" do
    it "displays signup form" do
      get :new
      expect(response).to render_template("new")
    end
  end

  describe "POST create" do
    it "signs up user" do
      post :create, :user => { :name => "robinhood", :email => "ksd@gma.com", :password => "asdf1234", :password_confirmation => "asdf1234" }
      expect(response).to redirect_to("/")
    end

    it "should render new in case of errors" do
      post :create, :user => { :name => "robinhood", :email => "ksd@gma.com", :password => "asdf1234", :password_confirmation => "af1234" }
      expect(response).to render_template(:new)
    end
  end

  describe "GET admin_area" do
    before :each do
      @user = User.new
      @user.name = "robinhood"
      @user.email = "rb@gmailed.com"
      @user.password = "asdf1234"
      @user.password_confirmation = "asdf1234"

      @user.save

			user = User.new
      user.name = "robinhood1"
      user.email = "rb@gmailed1.com"
      user.password = "asdf1234"
      user.password_confirmation = "asdf1234"
			user.save

		  user = User.new
      user.name = "robinhood2"
      user.email = "rb@gmailed2.com"
      user.password = "asdf1234"
      user.password_confirmation = "asdf1234"
      user.save
    end

    it "should redirect if the user is not admin" do
      session[:user_id] = @user.id

      get :admin_area
      expect(response).to redirect_to("/")
    end

    it "should render admin_area if user is admin" do
      @user.update_attribute(:role, "admin")
      session[:user_id] = @user.id

      get :admin_area
			assigns(:users).each do |u|
				expect(u.class.name).to eq("User")
			end
      expect(response).to render_template("admin_area")
    end
  end
	
	describe "GET show" do
		before :each do
			@user = User.new
      @user.name = "robinhood"
      @user.email = "rb@gmailed.com"
      @user.password = "asdf1234"
      @user.password_confirmation = "asdf1234"
			@user.role = "admin"
      @user.save

      user = User.new
      user.name = "robinhood1"
      user.email = "rb@gmailed1.com"
      user.password = "asdf1234"
      user.password_confirmation = "asdf1234"
      user.save
			zfile = user.z_files.new
			zfile.name = "abc.pdf"
			zfile.tempfile = Dir.pwd + "/spec/fixtures/files/abc.pdf"
			zfile.save
			@uid1 = user.id

      user = User.new
      user.name = "robinhood2"
      user.email = "rb@gmailed2.com"
      user.password = "asdf1234"
      user.password_confirmation = "asdf1234"
      user.save
			zfile = user.z_files.new
      zfile.name = "abc.pdf"
      zfile.tempfile = Dir.pwd + "/spec/fixtures/files/abc.pdf"
      zfile.save
    end

		it "should show list of files of user" do
			session[:user_id] = @user.id
			get :show, :id => @uid1
			assigns(:files).each do |f|
				expect(f.user.id).to eq(@uid1)
			end
		end
	end
end
