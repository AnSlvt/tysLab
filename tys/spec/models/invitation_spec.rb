require 'rails_helper'

RSpec.describe Invitation, type: :model do
  let(:user) { User.create!(name: 'AnSlvt', email: 'a@b.it') }
  let(:app) {
    Application.create!(application_name: 'app',
      author: user.id,
      programming_language: 'C#',
      github_repository: 'repo',
      authorization_token: 'abc')
  }
  let(:invitation_user) { User.create!(name: 'Leo', email: 'l@p.it') }

  context 'successfull creation' do
    it 'valid with valid attributes' do
      invite = Invitation.new(
        leader_name: user.name,
        target_name: invitation_user.name,
        application_id: app.id,
        invite_token: SecureRandom.urlsafe_base64(nil, true).to_s
      )
      expect(invite).to be_valid
    end
  end

  context 'unsuccessfull operation' do
    it 'fails becouse invite_token is not valid' do
      invite = Invitation.new(
        leader_name: user.name,
        target_name: invitation_user.name,
        application_id: app.id,
        invite_token: nil
      )
      expect(invite).to_not be_valid
    end

    it 'fails becouse leader_name is nil' do
      invite = Invitation.new(
        leader_name: nil,
        target_name: invitation_user.name,
        application_id: app.id,
        invite_token: SecureRandom.urlsafe_base64(nil, true).to_s)
      expect(invite).to_not be_valid
    end

    it 'fails becouse target_name is nil' do
      invite = Invitation.new(
        leader_name: user.name,
        target_name: nil,
        application_id: app.id,
        invite_token: SecureRandom.urlsafe_base64(nil, true).to_s)
      expect(invite).to_not be_valid
    end

    it 'fails becouse target_name is nil' do
      invite = Invitation.new(
        leader_name: user.name,
        target_name: invitation_user.name,
        application_id: nil,
        invite_token: SecureRandom.urlsafe_base64(nil, true).to_s)
      expect(invite).to_not be_valid
    end
  end
end
