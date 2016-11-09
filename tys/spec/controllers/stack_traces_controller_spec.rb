require 'rails_helper'
require_relative '../../lib/session_handler.rb'

RSpec.describe StackTracesController, type: :controller do

  context 'successfull operations' do

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

    context 'GET #show' do
      it 'shows the details of a given stack trace' do
        get :show, { user_id: user.id, application_id: app.id, id: stack.id}, { user_id: user.id }
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

    let(:user) { User.create!(name: 'AnSlvt', email: 'a@b.it') }
    let(:app) {
      Application.create!(application_name: 'app',
        author: user.id,
        programming_language: 'C#',
        github_repository: 'repo',
        authorization_token: 'abc')
    }

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

      it 'renders 404 because the user isn\'t logged in' do
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
        not_allowed_user = User.create!(name: 'ZioPeppo', email: 'a@b.it')
        put :update, { user_id: user.id, application_id: app.id, id: stack_trace_local.id}, { user_id: not_allowed_user.id }
        expect(response).to render_template(file: "#{Rails.root}/public/403.html")
        expect(response.status).to eq 403
      end
    end
  end
end
