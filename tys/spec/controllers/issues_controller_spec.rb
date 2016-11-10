require 'rails_helper'
require_relative '../../lib/session_handler.rb'

RSpec.describe IssuesController, type: :controller do

  context 'successfull operations' do

    let(:user) { User.create!(name: 'AnSlvt', email: 'a@b.it') }

    let(:app) {
      Application.create!(application_name: 'app',
        author: user.id,
        programming_language: 'C#',
        github_repository: 'AnSlvt/test_repo',
        authorization_token: 'abc')
    }

    let(:oct) { Octokit::Client.new(access_token: ENV['oct_test_token']) }

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

    context 'GET #index' do
      it 'shows the list of issues for a given stack trace' do
        get :index, { user_id: user.id, application_id: app.id, stack_trace_id: stack.id}, { user_id: user.id }
        expect(assigns(@stack_trace)[:stack_trace]).to be_kind_of(StackTrace)
        expect(response).to render_template 'index'
        expect(response.status).to eq 200
      end
    end

    context 'GET #new' do
      it 'Creates a new empty issue object' do
        get :new, { user_id: user.id, application_id: app.id, stack_trace_id: stack.id}, { user_id: user.id }
        expect(assigns(@stack_trace)[:stack_trace]).to be_kind_of(StackTrace)
        expect(assigns(@issue)[:issue]).to be_kind_of(Issue)
        expect(response).to render_template 'new'
        expect(response.status).to eq 200
      end
    end

    context 'POST #create' do
      it 'Creates a new issue' do
        SessionHandler.instance(oct)
        post :create, { user_id: user.id, application_id: app.id, stack_trace_id: stack.id, issue: { title: 'title', body: 'body' } }, { user_id: user.id }
        expect(assigns(@stack_trace)[:stack_trace]).to be_kind_of(StackTrace)
        expect(assigns(@issue)[:issue]).to be_kind_of(Issue)
        expect(response).to redirect_to user_application_stack_trace_issues_path(user.id, app.id, stack.id)
      end
    end
  end
end
