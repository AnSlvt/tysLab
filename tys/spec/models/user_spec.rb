require 'rails_helper'

RSpec.describe User, type: :model do

  let(:app) {
    Application.create!(application_name: 'app',
      author: 'AnSlvt',
      programming_language: 'C#',
      github_repository: 'repo',
      authorization_token: 'abc')
  }

  context 'successfull creation' do
    it "is valid with valid attributes" do
      user = User.new(name: 'Zio',
        email: 'a@b.it')
      expect(user).to be_valid
    end
  end

  context 'unsuccessful creation' do
    it 'fails because user name is missing' do
      user = User.new(email: 'a@b.it')
      expect(user).to_not be_valid
    end

    it 'fails because email is missing' do
      user = User.new(name: 'Zio')
      expect(user).to_not be_valid
    end

    it 'fails becouse email format is invalid' do
      user = User.new(name: 'Zio',
        email: 'lol.it@@')
      expect(user).to_not be_valid
    end
  end
end
