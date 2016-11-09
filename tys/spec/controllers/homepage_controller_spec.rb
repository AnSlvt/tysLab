require 'rails_helper'
require_relative '../../lib/session_handler.rb'

RSpec.describe HomepageController, type: :controller do

  context 'successfull operations' do

    let(:user) { User.create!(name: 'Pippo', email: 'a@b.it') }
    let(:app) {
      Application.create!(application_name: 'app',
        author: user.id,
        programming_language: 'C#',
        github_repository: 'repo',
        authorization_token: 'abc')
    }

    context 'GET #index' do
      it 'renders the homepage' do
        get :index
        expect(response).to render_template 'index'
        expect(response.status).to eq 200
      end
    end

    context 'GET #search' do
      it 'searches for a given application name or author' do
        get :search, { search_params: 'app' }
        expect(assigns(@applications)[:applications]).to be_kind_of(ActiveRecord::Relation)
        expect(assigns(@users)[:users]).to be_kind_of(ActiveRecord::Relation)
        expect(response).to render_template 'search'
        expect(response.status).to eq 200
      end
    end

    context 'GET #search_user' do
      it 'searches for a given user' do
        get :search_user, { search_params: 'Pippo' }
        expect(assigns(@users)[:users]).to be_kind_of(ActiveRecord::Relation)
        expect(response).to render_template 'search_user'
        expect(response.status).to eq 200
      end
    end
  end
end
