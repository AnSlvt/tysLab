require 'rails_helper'

RSpec.describe Feedback, type: :model do

  let(:app) {
    Application.create!(application_name: 'app',
      author: 'AnSlvt',
      programming_language: 'C#',
      github_repository: 'repo',
      authorization_token: 'abc')
  }

  let(:user) { User.create!(name: 'AnSlvt', email: 'a@b.it') }

  context 'successfull creation' do
    it "is valid with valid attributes (no parent)" do
      feedback = Feedback.new(text: 'Bella',
        application_id: app.id,
        feedback_type: 'Bug Report',
        email: 'a@b.it',
        user_name: 'pippo',
        parent_id: nil)
      expect(feedback).to be_valid
    end

    it "is valid with valid attributes (with parent)" do
      feedback1 = Feedback.new(text: 'Bella',
        application_id: app.id,
        feedback_type: 'Bug Report',
        email: 'a@b.it',
        user_name: 'pippo',
        parent_id: nil)

      feedback2 = Feedback.new(text: 'Bella',
        application_id: app.id,
        feedback_type: 'Bug Report',
        email: 'a@b.it',
        user_name: user.name,
        parent_id: feedback1.parent_id)

      expect(feedback1).to be_valid
      expect(feedback2).to be_valid
    end

    it 'is valid without email' do
      feedback1 = Feedback.new(text: 'Bella',
        application_id: app.id,
        feedback_type: 'Bug Report',
        email: nil,
        user_name: 'pippo',
        parent_id: nil)
      expect(feedback1).to be_valid
    end
  end

  context 'unsuccessful creation' do
    it 'fails becouse user name is missing' do
      feedback = Feedback.new(text: 'Bella',
        application_id: app.id,
        feedback_type: 'Bug Report',
        email: 'a@b.it',
        user_name: nil,
        parent_id: nil)
      expect(feedback).to_not be_valid
    end

    it 'fails becouse feedback_type is missing' do
      feedback = Feedback.new(text: 'Bella',
        application_id: app.id,
        feedback_type: nil,
        email: 'a@b.it',
        user_name: 'pippo',
        parent_id: nil)
      expect(feedback).to_not be_valid
    end

    it 'fails becouse text is missing' do
      feedback = Feedback.new(text: nil,
        application_id: app.id,
        feedback_type: 'Bug Report',
        email: 'a@b.it',
        user_name: 'pippo',
        parent_id: nil)
      expect(feedback).to_not be_valid
    end

    it 'fails becouse text is missing' do
      feedback = Feedback.new(text: 'bella',
        application_id: app.id,
        feedback_type: 'Bug Report',
        email: 'a@b',
        user_name: 'pippo',
        parent_id: nil)
      expect(feedback).to_not be_valid
    end

    it 'fails becouse application_id is associated to an invalid application' do
      application = Application.new(application_name: 'app',
        author: nil,
        programming_language: 'C#',
        github_repository: 'repo',
        authorization_token: 'abc')
      expect{
        Feedback.create!(text: 'Bella',
          application_id: application.id,
          feedback_type: 'Bug Report',
          email: 'a@b.it',
          user_name: 'pippo',
          parent_id: nil)
      }.to raise_error(ActiveRecord::StatementInvalid)
    end


  end
end
