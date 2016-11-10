require 'rails_helper'

RSpec.describe Application, type: :model do
  let(:user) {User.new(:name => "LeonardoPetrucci", :email => "leonardo.petrucci94@gmail.com")}

  context "successful creation" do
    it "is valid with valid attributes" do
      application = Application.new(
        author: user.name,
        application_name: "prova",
        programming_language: "C#",
        github_repository: "LeonardoPetrucci/toy_app"
      )
      expect(application).to be_valid
    end

    it "is valid without github repository" do
      application = Application.new(
        author: user.name,
        application_name: "prova",
        programming_language: "C#",
        github_repository: nil
      )
      expect(application).to be_valid
    end
  end

  context "unsuccessfull creation" do
    it "fails because author is missing" do
      expect{
        application = Application.create!(
          author: nil,
          application_name: "prova",
          programming_language: "C#",
          github_repository: "LeonardoPetrucci/toy_app"
        )
      }.to raise_error(ActiveRecord::StatementInvalid)
    end
    it "fails because application name is missing" do
      application = Application.new(
        author: user.name,
        application_name: nil,
        programming_language: "C#",
        github_repository: "LeonardoPetrucci/toy_app"
      )
      expect(application).to_not be_valid
    end
    it "fails because programming language is missing" do
      application = Application.new(
        author: user.name,
        application_name: "prova",
        programming_language: nil,
        github_repository: "LeonardoPetrucci/toy_app"
      )
      expect(application).to_not be_valid
    end
    it "fails because programming language is not supported" do
      application = Application.new(
        author: nil,
        application_name: "prova",
        programming_language: "ruby",
        github_repository: "LeonardoPetrucci/toy_app"
      )
      expect(application).to_not be_valid
    end
    it "fails becouse application_id is associated to an invalid application" do
      user = User.new(:name => nil, :email => "leonardo.petrucci94@gmail.com")
      expect {
        application = Application.create!(
          author: user.name,
          application_name: "prova",
          programming_language: "C#",
          github_repository: "LeonardoPetrucci/toy_app"
        )
      }.to raise_error(ActiveRecord::StatementInvalid)
    end
  end
end
