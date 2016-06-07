require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe "GET new" do
    it "displays login form" do
      get :new
      expect(response).to render_template("new")
    end
  end

  describe "POST create" do
    it "displays new with errors if the authentication fails" do
      user = User.new
      user.name = "robinhood"
      user.email = "rbhin@gmail.com"
      user.password = "asdf1234"
      user.password_confirmation = "asdf1234"
      user.save

      post :create, :user => { :email => "rbhin@gmail.com", :password => "asdfasdf" }
      expect(response).to render_template("new")
    end

    it "redirects on successful login" do
      user = User.new
      user.name = "robinhood"
      user.email = "rbhin@gmail.com"
      user.password = "asdf1234"
      user.password_confirmation = "asdf1234"
      user.save
      
      post :create, :user => { :email => "rbhin@gmail.com", :password => "asdf1234" }
      expect(response).to redirect_to("/")
    end
  end

  describe "GET logout" do
    it "should logout" do
      user = User.new
      user.name = "robinhood"
      user.email = "rbhin@gmail.com"
      user.password = "asdf1234"
      user.password_confirmation = "asdf1234"
      user.save
      session[:user_id] = user.id
      get :logout
      expect(response).to redirect_to("/")
    end
  end
end
