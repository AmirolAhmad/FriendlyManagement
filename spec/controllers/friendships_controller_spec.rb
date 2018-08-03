require 'rails_helper'

RSpec.describe FriendshipsController, type: :controller do
  describe "GET /friendlist" do

    it "returns http success with message email not found" do
      get :list

      hash_body = JSON.parse(response.body)
      expect(hash_body.keys).to match_array(["message"])
      expect(hash_body.values).to match_array(["email not found"])
      expect(response).to have_http_status(200)
    end

    it "returns http success with correct respond" do
      user = FactoryBot.create(:user, email: Faker::Internet.email)
      friendship = FactoryBot.create(:friendship, user: user)
      get :list, params: {email: user.email}

      hash_body = JSON.parse(response.body)
      expect(hash_body['success']).to eq(true)
      expect(response).to have_http_status(200)
    end

  end
end
