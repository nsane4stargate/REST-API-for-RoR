require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#validation' do

    let(:user) { create(:user) }

    it 'should have valid factory' do
      # Passing NO REQUIRED MISSING VALUES
      expect(user).to be_valid
      user.save!
    end

    it 'should validate presences of attributes' do
      # Fails REQUIRED MISSING VALUES
      user_two = build(:user, login: user.login = "", provider: user.provider = "")
      expect(user).not_to be_valid
      expect(user.errors[:login]).to include("can't be blank")
      expect(user.errors[:provider]).to include("can't be blank")
    end

    it 'has unique login' do
      user_two = build(:user, login: user.login)
      expect(user_two).not_to be_valid
      expect(user_two.errors[:login]).to include('has already been taken')
    end
  end
end
