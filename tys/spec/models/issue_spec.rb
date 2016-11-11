require 'rails_helper'

RSpec.describe Issue, type: :model do
  let(:user) {User.new(:name => "LeonardoPetrucci", :email => "leonardo.petrucci94@gmail.com")}
  let(:application){Application.new(
    author: user.name,
    application_name: "prova",
    programming_language: "C#",
    github_repository: "LeonardoPetrucci/toy_app"
  )}
  let(:stack_trace){StackTrace.new(
    application_id: 1,
    stack_trace_text: "stacktracetext",
    stack_trace_message: "stacktracemessage",
    application_version: "1.0.0",
    fixed: false,
    crash_time: 2016-10-10,
    error_type: "generic crash",
    device: "Nexus 5X"
    )}

  context "successful creation" do
    it "is valid with valid attributes" do
      issue = Issue.new(
        github_number: 1,
        stack_trace_id: 1,
        github_repository: application.github_repository
      )
      expect(issue).to be_valid
    end
  end

  context "unsuccessful creation" do
    it "fails because github number is missing" do
      issue = Issue.new(
        github_number: nil,
        stack_trace_id: 1,
        github_repository: application.github_repository
      )
      expect(issue).to_not be_valid
    end
    it "fails because github repository is missing" do
      issue = Issue.new(
        github_number: 1,
        stack_trace_id: stack_trace.id,
        github_repository: nil
      )
      expect(issue).to_not be_valid
    end
    it "fails because stack trace id is missing" do
      issue = Issue.new(
        github_number: 1,
        stack_trace_id: nil,
        github_repository: application.github_repository
      )
      expect(issue).to_not be_valid
    end
  end
end
