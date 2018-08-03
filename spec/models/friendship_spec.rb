require 'rails_helper'

RSpec.describe Friendship, type: :model do
  it "has a valid friendship factory" do
    expect(FactoryBot.build(:friendship)).to be_valid
  end

  describe "validation" do
    it { expect(FactoryBot.build(:friendship, user: FactoryBot.create(:user), friend: FactoryBot.create(:user))).to be_valid }
    it { expect(FactoryBot.build(:friendship, user: nil, friend: FactoryBot.create(:user))).not_to be_valid }
    it { expect(FactoryBot.build(:friendship, user: FactoryBot.create(:user), friend: nil)).not_to be_valid }
  end
end
