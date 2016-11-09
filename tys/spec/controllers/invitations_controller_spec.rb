require 'rails_helper'

RSpec.describe InvitationsController, type: :controller do

  let(:user) { User.create!(name: 'AnSlvt', email: 'a@b.it') }
  let(:app) {
    Application.create!(application_name: 'app',
      author: user.id,
      programming_language: 'C#',
      github_repository: 'repo',
      authorization_token: 'abc')
  }
  let(:invitation_user) { User.create!(name: 'Leo', email: 'l@p.it') }

  context 'Successfull operations' do

    context 'post #create' do
      it 'correctly create an Invitation instance' do
        post :create, {
          user_id: invitation_user.id,
          application_id: app.id
        }, { user_id: user.name }
        expect(assigns(@invite)[:invite]).to be_kind_of(Invitation)
        expect(assigns(@application)[:application]).to be_kind_of(Application)
        expect(assigns(@target)[:target]).to be_kind_of(User)
        expect(response).to redirect_to user_applications_path(user.id)
      end
    end

    context 'DELETE #destroy' do
      it 'correctly destroy an Invitation instance' do
        invite = Invitation.create!(
          leader_name: user.name,
          target_name: invitation_user.name,
          application_id: app.id,
          invite_token: SecureRandom.urlsafe_base64(nil, true).to_s
        )
        expect {
          delete :destroy, { user_id: invite.target_name, application_id: invite.application_id, id: invite.id }, {user_id: user.name}
        }.to change(Invitation, :count).by(-1)
        expect(response).to redirect_to user_applications_path(user.id)
      end
    end

  end

  context 'Unsuccessfull operations' do

    context 'post #create' do
      it 'renders 403 because the user is not allowed to invite other user becouse is not the author' do
        post :create, {
          user_id: user.id,
          application_id: app.id
        }, {user_id: invitation_user}
        expect(response).to render_template(file: "#{Rails.root}/public/403.html")
        expect(response.status).to eq 403
      end

      it 'renders 403 becouse the user is not a contributor of the application'do
        not_allowed_user = User.create!(name: 'marcozecchini', email: 'm@z.it')
        post :create, {
          user_id: user.id,
          application_id: app.id
        }, {user_id: not_allowed_user}
        expect(response).to render_template(file: "#{Rails.root}/public/403.html")
        expect(response.status).to eq 403
      end

      it 'renders 404 becouse the target_user is not in the db' do
        post :create, {
          user_id: 'marco',
          application_id: app.id
        }, {user_id: user.name}
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
        expect(response.status).to eq 404
      end

      it 'renders 404 becouse the application is not in the db' do
        post :create, {
          user_id: invitation_user.id,
          application_id: 12
        }, {user_id: user.name}
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
        expect(response.status).to eq 404
      end
    end

  end

  context 'DELETE #destroy' do
    it 'renders 401 because the user is not logged in' do
      delete :destroy, { user_id: 'AnSlvt', application_id: app.id, id: 1  }
      expect(response).to render_template(file: "#{Rails.root}/public/401.html")
      expect(response.status).to eq 401
    end

    it 'renders 404 if the Invitation istance does not exists' do
      delete :destroy, {user_id: invitation_user.name, application_id: app.id, id: 1}, {user_id: user.name}
      expect(response).to render_template(file: "#{Rails.root}/public/404.html")
      expect(response.status).to eq 404
    end

    it 'renders 404 if the current_user and the target_user are the different'do
      invite = Invitation.create!(
        leader_name: user.name,
        target_name: invitation_user.name,
        application_id: app.id,
        invite_token: SecureRandom.urlsafe_base64(nil, true).to_s
      )
      delete :destroy, {user_id: invitation_user.name, application_id: app.id, id: invite.id }, {user_id: user.id}
    end
    it 'renders 404 if the current_user and the leader_user are different'do
      invite = Invitation.create!(
        leader_name: user.name,
        target_name: user.name,
        application_id: app.id,
        invite_token: SecureRandom.urlsafe_base64(nil, true).to_s
      )
      delete :destroy, {user_id: invitation_user.name, application_id: app.id, id: invite.id }, {user_id: user.id}
    end
  end

end
