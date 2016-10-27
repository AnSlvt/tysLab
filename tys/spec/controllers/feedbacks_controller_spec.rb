require 'rails_helper'

RSpec.describe FeedbacksController, type: :controller do
  context "successfull operations" do

    let(:user) { User.create!(name: 'AnSlvt', email: 'a@b.it') }

    let(:app) {
      Application.create!(application_name: 'app',
        author: 'AnSlvt',
        programming_language: 'C#',
        github_repository: 'repo')
    }

    let(:public_feedback) {
      Feedback.create!(text: 'Bella',
        application_id: app.id,
        feedback_type: 'Bug Report',
        email: 'a@b.it',
        user_name: 'pippo',
        parent_id: nil)
    }

    context 'GET #new' do
      it 'render the new template' do
        get :new, { application_id: public_feedback.application_id, parent_id: public_feedback.id }, { user_id: app.author }
        expect(assigns(@application)[:application]).to be_kind_of(Application)
        expect(assigns(@user)[:user]).to be_kind_of(User)
        expect(response).to render_template 'new'
        expect(response.status).to eq 200
      end
    end

    context 'POST #create' do
      it 'creates the feedback and redirect to show public' do
        post :create, { application_id: public_feedback.application_id,
                        text: public_feedback.text,
                        feedback_type: public_feedback.feedback_type,
                        email: public_feedback.email,
                        user_name: public_feedback.user_name,
                        parent_id: public_feedback.parent_id }
        expect(assigns(@feedback)[:feedback]).to be_kind_of(Feedback)
        expect(response).to redirect_to user_application_show_public_path(app.author, app.id)
      end

      it 'creates the feedback as a response for another feedback' do
        post :create, { application_id: app.id,
                        text: "risposta",
                        feedback_type: 'Bug Report',
                        email: 'a@b.it',
                        user_name: app.author,
                        parent_id: public_feedback.id }, { user_id: app.author }
        expect(assigns(@feedback)[:feedback]).to be_kind_of(Feedback)
        expect(response).to redirect_to user_application_path(app.author, app.id)
      end
    end

    context 'DELETE #destroy' do
      it 'deletes a feedback only if the current_user is the one who wrote the feedback' do
        feedback = Feedback.create!(text: 'Bella',
          application_id: app.id,
          feedback_type: 'Bug Report',
          email: 'a@b.it',
          user_name: app.author,
          parent_id: nil)
        expect {
          delete :destroy, { application_id: app.id, id: feedback.id }, { user_id: feedback.user_name }
        }.to change(Feedback, :count).by(-1)
        expect(response).to redirect_to user_application_path(feedback.user_name, app.id)
      end
    end

    context 'GET #edit' do
      it 'render edit form for the feedback' do
        feedback = Feedback.create!(text: 'Bella',
          application_id: app.id,
          feedback_type: 'Bug Report',
          email: 'a@b.it',
          user_name: user.name,
          parent_id: nil)
        get :edit, { application_id: app.id, id: feedback.id }, { user_id: feedback.user_name}
        expect(response).to render_template 'edit'
        expect(assigns(@feedback)[:feedback]).to be_kind_of(Feedback)
        expect(assigns(@feedback)[:feedback][:text]).to eq 'Bella'
        expect(assigns(@feedback)[:feedback][:feedback_type]).to eq 'Bug Report'
      end
    end

    context 'PUT/PATCH #update' do
      it 'updates the feedback in the database' do
        feedback = Feedback.create!(text: 'Bella',
          application_id: app.id,
          feedback_type: 'Bug Report',
          email: 'a@b.it',
          user_name: user.name,
          parent_id: nil)
        put :update, { application_id: app.id,
                      id: feedback.id,
                      text: 'new_text',
                      feedback_type: 'Feedback' }, { user_id: feedback.user_name }
        expect(response).to redirect_to user_application_path(user.id, app.id)
        expect(assigns(@feedback)[:feedback][:text]).to eq 'new_text'
        expect(assigns(@feedback)[:feedback][:feedback_type]).to eq 'Feedback'
      end
    end
  end

  context "unsuccessfull operations" do

  end
end
