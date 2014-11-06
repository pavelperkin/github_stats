require 'rails_helper'

RSpec.describe ReposController, :type => :controller do

  describe "GET toggle_activation" do
    it "returns http success" do
      get :toggle_activation
      expect(response).to be_success
    end
  end

end
