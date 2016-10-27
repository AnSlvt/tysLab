require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  it 'have to show the profile for AnSlvt' do
    get :show, { id: 'AnSlvt' }, { user_id: 'AnSlvt' }
    expect(response).to render_template('show')
  end
end
