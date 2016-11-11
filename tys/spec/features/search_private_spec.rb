require 'rails_helper'
require 'rack_session_access/capybara'

RSpec.describe "Search private", :type => :feature do
#  let(:user) {User.create!(name: 'AnSlvt', email: 'a@b.it') }
  scenario "visit applications" do
    first = initialize_first_user
    visit_applications first
    app = initialize_data first
    expect(page).to have_content("Your Application List")
    expect(page).to have_content("#{app.application_name}")
  end

  scenario "fill search field" do
    first = initialize_first_user
    visit_applications first
    initialize_data first
    init_user
    search_an_user
    expect(page).to have_content("mz")
  end

  scenario "go to user_page" do
    first = initialize_first_user
    visit_applications first
    initialize_data first
    user = init_user
    search_an_user
    click_on_button user
    expect(page).to have_content("Details about #{user.name}")
  end

  def visit_applications(user)
    page.set_rack_session(:user_id => user.name)
    visit user_applications_path(user.name)
  end

  def initialize_first_user
    User.create!(name: 'AnSlvt', email: 'a@b.it')
  end

  def initialize_data(user)
    application = Application.create!(application_name: 'app',
      author: user.id,
      programming_language: 'C#',
      github_repository: 'repo',
      authorization_token: 'abc')
    application
  end

  def init_user
    user = User.create!(name: 'mz', email: 'm@z.it')
    user
  end

  def search_an_user
    fill_in "home_search", :with => "m"
    click_button "search"
  end

  def click_on_button(user)
    click_on "button-user-#{user.name}"
  end  
end
