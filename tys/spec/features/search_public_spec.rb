require 'rails_helper'

RSpec.describe "Search public", :type => :feature do
  let(:user) {User.create!(name: 'AnSlvt', email: 'a@b.it') }
  scenario "Search in the navbar" do
    application = initialize_data
    search_an_application
    expect(page).to have_content("#{application.application_name}")
  end

  scenario "Select an application in Search Results View" do
    application = initialize_data
    search_an_application
    select_application_from_list application
    expect(page).to have_content("#{application.application_name} by #{application.author}")
  end

  scenario "Add a feedback to show_public" do
    application = initialize_data
    search_an_application
    select_application_from_list application
    insert_feedback_data
    expect(page).to have_content("Marco")
  end

  def initialize_data
    application = Application.create!(application_name: 'app',
      author: user.id,
      programming_language: 'C#',
      github_repository: 'repo',
      authorization_token: 'abc')
    application
  end

  def search_an_application
    visit "/"
    fill_in "home_search", :with => "A"
    click_button "search"
  end
  def select_application_from_list(application)
    click_on "show_public_button_#{application.application_name}"
  end

  def insert_feedback_data
      fill_in "text", :with => "Inserito testo"
      fill_in "user_name", :with => "Marco"
      click_on "Send"
  end
end
