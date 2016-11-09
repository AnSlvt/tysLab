require 'rails_helper'

RSpec.describe FeedbacksController, type: :controller do

  let(:user) { User.create!(name: 'AnSlvt', email: 'a@b.it') }

  let(:app) {
    Application.create!(application_name: 'app',
      author: 'AnSlvt',
      programming_language: 'C#',
      github_repository: 'repo',
      authorization_token: 'abc')
  }

  let(:public_feedback) {
    Feedback.create!(text: 'Bella',
      application_id: app.id,
      feedback_type: 'Bug Report',
      email: 'a@b.it',
      user_name: 'pippo',
      parent_id: nil)
  }

  context "successfull operations" do

    context 'GET #new' do
      it 'render the new template' do
        app.users << user
        get :new, { application_id: public_feedback.application_id, parent_id: public_feedback.id }, { user_id: user.name }
        expect(assigns(@application)[:application]).to be_kind_of(Application)
        expect(assigns(@user)[:user]).to be_kind_of(User)
        expect(assigns(@target)[:target]).to be_kind_of(Feedback)
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
          delete :destroy, { application_id: app.id, id: feedback.id }, { user_id: user.name }
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

    let(:feedback) { Feedback.create!(
      text: 'Bella',
      application_id: app.id,
      feedback_type: 'Bug Report',
      email: 'a@b.it',
      user_name: user.id,
      parent_id: nil
    )}

    context 'GET #new' do
      it 'renders 404 if the application does not exists' do
        get :new, { application_id: 1, parent_id: public_feedback.id }, { user_id: user.name }
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
        expect(response.status).to eq 404
      end

      it 'renders 404 if the parent id is not valid' do
        get :new, { application_id: app.id, parent_id: 99 }, { user_id: user.name }
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
        expect(response.status).to eq 404
      end

      it 'renders 401 if the user is not logged in' do
        get :new, { application_id: app.id, parent_id: public_feedback.id }
        expect(response).to render_template(file: "#{Rails.root}/public/401.html")
        expect(response.status).to eq 401
      end

      it 'renders 403 if the user who tries to make a response is not a contributor of the application' do
        not_allowed_user = User.create!( name: 'LeonardoPetrucci', email: 'a@c.it' )
        get :new, { application_id: app.id, parent_id: public_feedback.id }, { user_id: not_allowed_user.name }
        expect(response).to render_template(file: "#{Rails.root}/public/403.html")
        expect(response.status).to eq 403
      end
    end

    context 'DELETE #destroy' do

      it 'renders 404 if the feedback does not exists' do
        delete :destroy, { application_id: app.id, id: 99 }, { user_id: user.name }
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
        expect(response.status).to eq 404
      end

      it 'renders 404 if the couple app_id-feedback_id does not exists' do
        test_app = Application.create!(application_name: 'app',
          author: 'AnSlvt',
          programming_language: 'C#',
          github_repository: 'repo',
          authorization_token: 'abc')
        delete :destroy, { application_id: test_app.id, id: public_feedback.id }, { user_id: user.id }
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
        expect(response.status).to eq 404
      end

      it 'renders 403 if the user who attemps to permorm the destroy is not the author' do
        not_allowed_user = User.create!( name: 'LeonardoPetrucci', email: 'a@c.it' )
        delete :destroy, { application_id: app.id, id: public_feedback.id }, { user_id: not_allowed_user.name }
        expect(response).to render_template(file: "#{Rails.root}/public/403.html")
        expect(response.status).to eq 403
      end

      it 'renders 401 if the user is not logged in' do
        delete :destroy, { application_id: app.id, id: public_feedback.id }
        expect(response).to render_template(file: "#{Rails.root}/public/401.html")
        expect(response.status).to eq 401
      end
    end

    context 'GET #edit' do

      it 'renders 404 if the feedback does not exists' do
        get :edit, { application_id: app.id, id: 99}, { user_id: user.name }
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
        expect(response.status).to eq 404
      end

      it 'renders 404 if the couple app_id-feedback_id does not exists' do
        test_app = Application.create!(application_name: 'app',
          author: 'AnSlvt',
          programming_language: 'C#',
          github_repository: 'repo',
          authorization_token: 'abc')
        get :edit, { application_id: test_app.id, id: public_feedback.id}, { user_id: user.name }
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
        expect(response.status).to eq 404
      end

      it 'renders 403 if the user is not the author of the feedback' do
        usr = User.create!( name: 'LeonardoPetrucci', email: 'a@f.it' )
        get :edit, { application_id: app.id, id: feedback.id }, { user_id: usr.name }
        expect(response).to render_template(file: "#{Rails.root}/public/403.html")
        expect(response.status).to eq 403
      end

      it 'renders 401 if the user is not logged in' do
        get :edit, { application_id: app.id, id: public_feedback.id }
        expect(response).to render_template(file: "#{Rails.root}/public/401.html")
        expect(response.status).to eq 401
      end
    end

    context 'PATCH/PUT #update' do
      it 'renders 404 if the feedback does not exists' do
        put :update, { application_id: app.id, id: 99 }, { user_id: user.id }
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
        expect(response.status).to eq 404
      end

      it 'renders 404 if the couple application_id-feedback_id does not exists' do
        test_app = Application.create!(application_name: 'app',
          author: 'AnSlvt',
          programming_language: 'C#',
          github_repository: 'repo',
          authorization_token: 'abc')
        put :update, { application_id: test_app.id, id: public_feedback.id }, { user_id: user.id }
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
        expect(response.status).to eq 404
      end

      it 'renders 403 if the user is not the author of the feedback' do
        usr = User.create!( name: 'LeonardoPetrucci', email: 'a@f.it' )
        put :update, { application_id: app.id, id: feedback.id }, { user_id: usr.name }
        expect(response).to render_template(file: "#{Rails.root}/public/403.html")
        expect(response.status).to eq 403
      end

      it 'renders 401 if the user is not logged in' do
        put :update, { application_id: app.id, id: public_feedback.id }
        expect(response).to render_template(file: "#{Rails.root}/public/401.html")
        expect(response.status).to eq 401
      end
    end

    context 'POST #create' do
      # TODO: implement this
    end
  end
end
