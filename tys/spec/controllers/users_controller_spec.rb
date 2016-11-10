require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let(:user) { User.create!( name: 'AnSlvt', email: 'a@b.it' )}

  context 'succesfull operations' do

    context 'GET #show' do
      it 'renders the show template for the user' do
        get :show, { id: user.id }, { user_id: user.id }
        expect(response).to render_template 'show'
        expect(response.status).to eq 200
      end
    end

    context 'GET #edit' do
      it 'renders the edit template for the user information' do
        get :edit, { id: user.id }, { user_id: user.id }
        expect(response).to render_template 'edit'
        expect(response.status).to eq 200
      end
    end

    context 'GET #show_public' do
      it 'renders show_public template' do
        get :show_public, { user_id: user.id }
        expect(assigns(@user)[:user]).to be_kind_of(User)
        expect(response).to render_template 'show_public'
        expect(response.status).to eq 200
      end
    end

    context 'PUT/PATCH #update' do
      it 'performs the update operation on the user\'s info' do
        usr = User.create!( name: 'AB', email: 'cd@ef.it' )
        put :update, { id: usr.id, secondary_email: 'aa@bb.it' }, { user_id: usr.id }
        expect(assigns(@user)[:user][:secondary_email]).not_to eq nil
        expect(assigns(@user)[:user][:secondary_email]).to eq 'aa@bb.it'
      end
    end
  end

  context 'unsuccesfull operations' do
    context 'GET #show' do
      it 'renders 404 if the user does not exists' do
        get :show, { id: -1 }, { user_id: user.id }
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
        expect(response.status).to eq 404
      end

      it 'renders 401 if the user is not logged in' do
        get :show, { id: user.id }
        expect(response).to render_template(file: "#{Rails.root}/public/401.html")
        expect(response.status).to eq 401
      end
    end

    context 'GET #show_public' do
      it 'renders 404 if the user does not exists' do
        get :show_public, { user_id: -1 }
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
        expect(response.status).to eq 404
      end
    end

    context 'PUT/PATCH #update' do
      it 'renders 404 if the user does not exists' do
        put :update, { id: -1 }, { user_id: user.id }
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
        expect(response.status).to eq 404
      end

      it 'renders 403 if the user is not allowed' do
        not_allowed_user = User.create!( name: 'a', email: 'i@i.it' )
        put :update, { id: user.id }, { user_id: not_allowed_user.id }
        expect(response).to render_template(file: "#{Rails.root}/public/403.html")
        expect(response.status).to eq 403
      end
    end
  end
end
