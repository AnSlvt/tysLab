require 'rails_helper'

RSpec.describe StackTrace, type: :model do

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
      stack = StackTrace.new(application_id: app.id,
      error_type: "ciao",
      crash_time: DateTime.now,
      application_version: "1.2.0.0")
      expect(stack).to be_valid
    end
  end

  context 'unsuccessful creation' do
    it 'fails because application is missing' do
      stack = StackTrace.new(error_type: "ciao",
      crash_time: DateTime.now,
      application_version: "1.2.0.0")
      expect(stack).to_not be_valid
    end

    it 'fails because error type is missing' do
      stack = StackTrace.new(application_id: app.id,
      crash_time: DateTime.now,
      application_version: "1.2.0.0")
      expect(stack).to_not be_valid
    end

    it 'fails because crash time is missing' do
      stack = StackTrace.new(application_id: app.id,
      error_type: "ciao",
      application_version: "1.2.0.0")
      expect(stack).to_not be_valid
    end

    it 'fails because app version is missing' do
      stack = StackTrace.new(application_id: app.id,
      error_type: "ciao",
      crash_time: DateTime.now)
      expect(stack).to_not be_valid
    end
  end
end
