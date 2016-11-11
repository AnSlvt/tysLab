require 'rails_helper'

RSpec.describe Contributor, type: :model do

  let(:app) {
    Application.create!(application_name: 'app',
      author: 'AnSlvt',
      programming_language: 'C#',
      github_repository: 'repo',
      authorization_token: 'abc')
  }
  let(:user) { User.create!(name: 'AnSlvt', email: 'a@b.it') }

  context 'successfull creation' do
    it "is valid with valid attributes" do
      contr = Contributor.new(user_id: user.id,
        application_id: app.id)
      expect(contr).to be_valid
    end
  end

  context 'unsuccessful creation' do
    it 'fails because user is missing' do
      contr = Contributor.new(user_id: nil,
        application_id: app.id)
      expect(contr).to_not be_valid
    end

    it 'fails because app is missing' do
      contr = Contributor.new(user_id: user.id,
        application_id: nil)
      expect(contr).to_not be_valid
    end
  end
end
