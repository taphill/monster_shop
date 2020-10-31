require 'rails_helper'

describe User, type: :model do
  describe 'validations' do
    it { should have_secure_password }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:street_address) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }

    it { should validate_uniqueness_of(:email) }
  end

  describe 'relationships' do
    describe 'is a merchant' do
      before { allow(subject).to receive(:role).and_return('merchant')}
      it { should belong_to :merchant}
    end
  end
end
