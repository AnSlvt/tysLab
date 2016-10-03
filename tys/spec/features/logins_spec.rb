require 'spec_helper'

RSpec.feature "User logins", type: :feature do
  scenario 'by click the Login button' do
    visit "/"
    click_button "Login"
    expect(page).to have_text("#{current_user.name} succesfully logged in!")
  end
end
