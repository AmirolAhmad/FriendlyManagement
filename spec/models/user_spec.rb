require 'rails_helper'

RSpec.describe User, type: :model do

  it "has a valid user factory" do
    expect(FactoryBot.build(:user)).to be_valid
  end

  describe "validation" do

    it { expect(FactoryBot.build(:user, email: Faker::Internet.email)).to be_valid }
    it { expect(FactoryBot.build(:user, email: nil)).not_to be_valid }

  end

end
