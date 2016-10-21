require 'rails_helper'
require_relative '../../lib/session_handler.rb'

RSpec.describe ApplicationsController, type: :controller do

  context 'successfull operations' do

    let(:user) { User.create!(name: 'AnSlvt', email: 'a@b.it') }
    let(:app) {
      Application.create!(application_name: 'app',
        author: user.id,
        programming_language: 'C#',
        github_repository: 'repo')
    }
    FactoryGirl.define do
      factory :application do
        application_name "App"
        author  "AnSlvt"
        programming_language "C#"
        github_repository 'repo'
      end
    end
    let(:oct) { Octokit::Client.new(access_token: ENV['oct_test_token']) }
    let (:contr) {
      Contributor.create!(user_id: 'LeonardoPetrucci',
        application_id: app.id)
    }

    context 'GET #new' do
      it 'render the new form and get the repos list' do
        SessionHandler.instance(oct)
        get :new, { user_id: 'AnSlvt' }, { user_id: user.id }
        expect(assigns(@application)[:application]).to be_kind_of(Application)
        expect(assigns(@repos)).to_not eq nil
        expect(response).to render_template 'new'
      end
    end

    context 'GET #index' do
      it 'show the applications list for the current user' do
        get :index, { user_id: 'AnSlvt' }, { user_id: 'AnSlvt' }
        expect(response).to render_template 'index'
      end
    end

    context 'POST #create' do

      it 'create an application' do
        create_params = FactoryGirl.attributes_for(:application)
        expect {
          post :create, {  user_id: 'AnSlvt', application: create_params }, { user_id: user.id }
        }.to change(Application, :count).by(1)
        expect(response).to render_template 'create'
        expect(Application.all.count).to_not eq(0)
      end
    end

    context 'GET #show' do
      it "show application detail" do
        get :show, { user_id: app.author, id: app.id }, { user_id: user.id }
        expect(assigns(@application)).to_not eq nil
        expect(response).to render_template 'show'
      end

      it 'show app details to a contributor' do
        get :show, { user_id: app.author, id: app.id }, { user_id: contr.user_id }
        expect(response).to render_template 'show'
        expect(response.status).to eq 200
      end
    end

    context 'DELETE #destroy' do
      it 'delete an app' do
        application = Application.create(application_name: 'app',
          author: 'AnSlvt',
          programming_language: 'C#',
          github_repository: 'repo')
        expect {
          delete :destroy, { user_id: application.author, id: application.id }, { user_id: application.author }
        }.to change(Application, :count).by(-1)
        expect(response).to redirect_to user_applications_path
      end
    end

    context 'GET #show_public' do
      it 'shows public details for app even if the user is not logged in' do
        get :show_public, { user_id: app.author, application_id: app.id }, { user_id: '' }
        expect(assigns(@application)).not_to eq nil
        expect(response).to render_template 'show_public'
      end

      it 'shows public details for app' do
        get :show_public, { user_id: app.author, application_id: app.id }, { user_id: user.id }
        expect(assigns(@application)).not_to eq nil
        expect(response).to render_template 'show_public'
      end
    end
  end

  context 'unsuccessfull operations' do

    let(:app) {
      Application.create!(application_name: 'app',
        author: 'AnSlvt',
        programming_language: 'C#',
        github_repository: 'repo')
    }

    context 'GET #index' do
      it 'render 404 because the session does not contain a user' do
        get :index, { user_id: 'AnSlvt' }, { user_id: '' }
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
      end
    end

    context 'GET #show' do
      it 'render 404 because does not find the application' do
        get :show, { user_id: 'AnSlvt', id: 1 }, { user_id: 'AnSlvt' }
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
      end

      it 'render 404 because the current user is not allowed' do
        get :show, { user_id: 'AnSlvt', id: app.id }, { user_id: 'LeonardoPetrucci' }
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
      end

      it 'render 404 because the couple user_id id does not exists' do
        get :show, { user_id: '', id: app.id }, { user_id: app.author }
        expect(assigns(@application)[:application]).to eq nil
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
        #expect(response.status).to eq 404
      end
    end

    context 'DELETE #destroy' do

      it 'fails because of the current user' do
        delete :destroy, { user_id: 'AnSlvt', id: app.id }, { user_id: '' }
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
      end

      it 'render 404 because does not find the application' do
        delete :destroy, { user_id: 'AnSlvt', id: 1 }, { user_id: 'AnSlvt' }
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
      end

      it 'render 403 because the current user is not the author of the application' do
        delete :destroy, { user_id: 'LeonardoPetrucci', id: app.id }, { user_id: 'LeonardoPetrucci' }
        expect(response).to render_template(file: "#{Rails.root}/public/403.html")
      end
    end

    context 'GET #show_public' do
      it 'render 404 because the app does not exist' do
        get :show_public, { user_id: 'AnSlvt', application_id: 1 }
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
        expect(response.status).to eq 404
      end

      it 'render 404 because the couple user_id application_id does not exists' do
        get :show_public, { user_id: '', application_id: app.id }
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
        expect(response.status).to eq 404
      end
    end
  end
end
