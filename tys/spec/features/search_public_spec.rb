require 'rails_helper'

RSpec.describe "Search public", :type => :feature do
  let(:user) {User.create!(name: 'AnSlvt', email: 'a@b.it') }
  let(:app) {
    Application.create!(application_name: 'app',
      author: user.id,
      programming_language: 'C#',
      github_repository: 'repo',
      authorization_token: 'abc')
  }
  scenario "Search in the navbar" do
    visit "/"
    fill_in "home_search", :with => "a"
    click_button "search"

    expect(page).to have_content("Search Results")
  end

  scenario "Select an application in Search Results View" do
    application = Application.create!(application_name: 'app',
      author: user.id,
      programming_language: 'C#',
      github_repository: 'repo',
      authorization_token: 'abc')

    visit "/"
    fill_in "home_search", :with => "A"
    click_button "search"

    click_on "show_public_button_#{application.application_name}"
    expect(page).to have_content("A")
  end

end
