ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "test_helper"

class ActiveSupport::TestCase
  fixtures :all
end

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new (name: "Example User", email: "user@example.com")
  end

  test "should be valid" do
    assert @user.valid?
  end
end
