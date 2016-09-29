require 'spec_helper'

RSpec.describe UsersController, type: :controller do
  context "when a client perform a login action" do
    before { @access_token = 'cca2f9933f2217792bd1931d0f42f6e9c3c17b15' }
    it "assign the @user variable to the current user" do
      subject { get :login }
      expect(@user).not_to be_nil
    end
  end
end
