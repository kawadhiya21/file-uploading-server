require 'test_helper'
require 'digest/md5'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should not save blank user" do
    user = User.new
    assert_not user.save
  end

  test "should not save user with name less than 4 character" do
    user = User.new
    user.name = "2ch"
    assert_not user.save
    user.errors.full_messages.include? "Name is too short (minimum is 4 characters)"
  end

  test "should not save user with no email" do
    user = User.new
    user.name = "Robinhood"
    assert_not user.save
    assert user.errors.full_messages.include? "Email can't be blank"
  end

  test "should not save user with bad email format" do
    user = User.new
    user.name = "Robinhood"
    user.email = "kkk"
    assert_not user.save
    assert user.errors.full_messages.include? "Email is invalid"
  end

  test "should not save user if password is short" do
    user = User.new
    user.name = "Robinhood"
    user.email = "kkk@gmail.com"
    user.password = "as"
    assert_not user.save
    assert user.errors.full_messages.include? "Password is too short (minimum is 6 characters)"
  end

  test "Should save user if all fields are validated" do
    user = User.new
    user.name = "Robinhood"
    user.email = "kkk@gmail.com"
    user.password = "asdf1234"
    assert user.save
  end
  
  test "Should not save user if email is same" do
    user = User.new
    user.name = "Robinhood"
    user.email = "kkk@gmail.com"
    user.password = "asdf1234"
    user.save
    user.id = nil
    user.password = "asdf1234"
    assert_not user.save
    assert user.errors.full_messages.include? "Email has already been taken"
  end

  test "Should hash password before save" do
    user = User.new
    user.name = "Robinhood"
    user.email = "kkk@gmail.com"
    password = "asdf1234"
    user.password = password
    user.save
    assert_not user.password == password
    assert Digest::MD5.hexdigest(password) == user.password
  end

  test "Default role should be user" do
    user = User.new
    user.name = "Robinhood"
    user.email = "kkk@gmail.com"
    password = "asdf1234"
    user.password = password
    user.save
    assert user.role == "user"
  end

  test "Should not authenticate if password is wrong" do
    user = User.new
    user.name = "Robinhood"
    user.email = "kkk@gmail.com"
    password = "asdf1234"
    user.password = password
    user.save
    new_user = User.new
    new_user.email = "kkk@gmail.com"
    new_user.password = "asfffff"
    assert_not new_user.authenticate
  end

  test "Should authenticate the user if password is correct" do
    user = User.new
    user.name = "Robinhood"
    user.email = "kkk@gmail.com"
    password = "asdf1234"
    user.password = password
    user.save
    new_user = User.new
    new_user.email = "kkk@gmail.com"
    new_user.password = "asdf1234"
    authenticated_user = new_user.authenticate
    assert  authenticated_user == user
  end
end
