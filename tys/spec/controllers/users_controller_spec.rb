require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let(:user) { User.create!( name: 'AnSlvt', email: 'a@b.it')}

  it 'have to show the profile for the user' do
    get :show, { id: user.id }, { user_id: user.id }
    expect(response).to render_template('show')
  end
end
