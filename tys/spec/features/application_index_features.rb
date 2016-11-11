require 'rails_helper'
require_relative '../../lib/session_handler.rb'

RSpec.feature "Application Index features", type: :feature do

  scenario "Logged user creates a new application" do
    SessionHandler.instance(Octokit::Client.new(access_token: ENV['oct_test_token']))
    user = User.new(:name => "LeonardoPetrucci", :email => "leonardo.petrucci94@gmail.com")
    page.set_rack_session(:user_id => user.name)
    visit user_applications_path(user)
    click_on "New Application"

    fill_in "Name", with: "Sample"

    click_on "Create"

    expect(page).to have_text("Sample was successfully created.")
  end

  scenario "User Logged out" do
    user = User.new(:name => "LeonardoPetrucci", :email => "leonardo.petrucci94@gmail.com")
    page.set_rack_session(:user_id => user.name)
    visit user_applications_path(user)
    click_on "Logout"
    expect(page).to have_text("Logged out!")
  end


end
