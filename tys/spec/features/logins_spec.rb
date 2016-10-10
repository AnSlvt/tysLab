require 'spec_helper'

RSpec.feature "User logins", type: :feature do
  scenario 'by click the Login button' do
    #it 'should be redirected on Github for authorization' do
    visit "/"
    click_button "Login"
    response.should redirect_to('https://github.com/login/oauth/authorize')
    #expect(page).to have_text("#{current_user.name} succesfully logged in!")
    #end
  end
end
