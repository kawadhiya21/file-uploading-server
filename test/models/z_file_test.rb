require 'test_helper'
require 'fileutils'

class ZFileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should not save blank ZFile" do
    zfile = ZFile.new
    assert_not zfile.save_file
    assert_not zfile.save
  end

  test "should not save without a user" do
    zfile = ZFile.new
    zfile.name = "asdf"
    FileUtils.touch(Dir.pwd + "/test/testing.txt")
    zfile.tempfile = Dir.pwd + "/test/testing.txt"
    zfile.save_file
    assert zfile.errors.full_messages.include? "User can't be blank"
  end

  test "should save file with a proper user" do
    user = User.new
    user.name = "Robinhood"
    user.email = "asdfasd@gmail.com"
    user.password = "asdf1234"
    user.save

    file = user.z_files.new
    file.name = "asdf"
    FileUtils.touch(Dir.pwd + "/test/testing.txt")
    file.tempfile = Dir.pwd + "/test/testing.txt"
    assert file.save_file
    assert file.user == user
    assert file.name == "asdf"
    assert File.file?(File.join(file.class::DIRECTORY, file.file_hash))
  end
end
