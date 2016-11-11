require 'rails_helper'
require_relative '../../lib/session_handler.rb'

RSpec.describe StackTracesController, type: :controller do

  let(:user) { User.create!(name: 'AnSlvt', email: 'a@b.it') }

  let(:app) {
    Application.create!(application_name: 'app',
      author: user.id,
      programming_language: 'C#',
      github_repository: 'repo',
      authorization_token: 'abc')
  }

  let(:stack) {
    StackTrace.create!(
      application_id: app.id,
      stack_trace_text: 'Ciao',
      stack_trace_message: 'Messaggio a caso',
      application_version: '1.2.0.0',
      fixed: false,
      crash_time: DateTime.now,
      error_type: 'NullReferenceException',
      device: 'Lumia 950XL'
    )
  }

  context 'successfull operations' do

    context 'GET #show' do
      it 'shows the details of a given stack trace' do
        app.users << user
        get :show, { user_id: user.id, application_id: app.id, id: stack.id }, { user_id: user.id }
        expect(assigns(@report)[:report]).to be_kind_of(StackTrace)
        expect(assigns(@most_recent)[:report]).to be_kind_of(StackTrace)
        expect(assigns(@first_time)[:report]).to be_kind_of(StackTrace)
        expect(response).to render_template 'show'
        expect(response.status).to eq 200
      end
    end

    context 'PUT/PATCH #update' do
      it 'updates the fixed status of a stack trace' do
        stack_trace_local = StackTrace.create!(
          application_id: app.id,
          stack_trace_text: 'Ciao',
          stack_trace_message: 'Messaggio a caso',
          application_version: '1.2.0.0',
          fixed: false,
          crash_time: DateTime.now,
          error_type: 'NullReferenceException',
          device: 'Lumia 950XL'
        )
        put :update, { user_id: user.id, application_id: app.id, id: stack_trace_local.id}, { user_id: user.id }
        expect(response).to redirect_to user_application_path(user.id, app.id)
        expect(assigns(@stack_trace)[:stack_trace][:fixed]).to eq true
      end
    end
  end

  context 'unsuccessfull operations' do

    context 'GET #show' do
      it 'renders 404 if the stack trace does not exists' do
        app.users << user
        get :show, { user_id: user.id, application_id: app.id, id: 99 }, { user_id: user.id }
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
        expect(response.status).to eq 404
      end

      it 'renders 404 if the application which the stack trace refers does not exists' do
        get :show, { user_id: user.id, application_id: 99, id: stack.id }, { user_id: user.id }
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
        expect(response.status).to eq 404
      end

      it 'renders 404 if the user doesn\'t have the application referred' do
        usr = User.create!( name: 'peppe', email: 'a@f.it' )
        get :show, { user_id: usr.id, application_id: app.id, id: stack.id }, { user_id: usr.id }
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
        expect(response.status).to eq 404
      end

      it 'renders 403 if the current user is neither a contributor nor the author of the application' do
        not_allowed_user = User.create!( name: 'LeonardoPetrucci', email: 'a@j.it' )
        get :show, { user_id: user.id, application_id: app.id, id: stack.id }, { user_id: not_allowed_user.id}
        expect(response).to render_template(file: "#{Rails.root}/public/403.html")
        expect(response.status).to eq 403
      end

      it 'renders 401 if the user is not logged in' do
        get :show, { user_id: user.id, application_id: app.id, id: stack.id }
        expect(response).to render_template(file: "#{Rails.root}/public/401.html")
        expect(response.status).to eq 401
      end
    end

    context 'PUT/PATCH #update' do
      it 'renders 404 because a stack trace isn\'t found' do
        stack_trace_local = StackTrace.create!(
          application_id: app.id,
          stack_trace_text: 'Ciao',
          stack_trace_message: 'Messaggio a caso',
          application_version: '1.2.0.0',
          fixed: false,
          crash_time: DateTime.now,
          error_type: 'NullReferenceException',
          device: 'Lumia 950XL'
          )
        put :update, { user_id: user.id, application_id: 99, id: stack_trace_local.id}, { user_id: user.id }
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
        expect(response.status).to eq 404
      end

      it 'renders 403 because the user isn\'t allowed to update' do
        stack_trace_local = StackTrace.create!(
          application_id: app.id,
          stack_trace_text: 'Ciao',
          stack_trace_message: 'Messaggio a caso',
          application_version: '1.2.0.0',
          fixed: false,
          crash_time: DateTime.now,
          error_type: 'NullReferenceException',
          device: 'Lumia 950XL'
          )
        not_allowed_user = User.create!(name: 'ZioPeppo', email: 'a@z.it')
        put :update, { user_id: user.id, application_id: app.id, id: stack_trace_local.id}, { user_id: not_allowed_user.id }
        expect(response).to render_template(file: "#{Rails.root}/public/403.html")
        expect(response.status).to eq 403
      end

      it 'renders 401 if the user is not logged in' do
        put :update, { user_id: user.id, application_id: app.id, id: stack.id }
        expect(response).to render_template(file: "#{Rails.root}/public/401.html")
        expect(response.status).to eq 401
      end
    end
  end
end
