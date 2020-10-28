require 'rails_helper'

describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:street_address) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }

    it { should validate_uniqueness_of(:email) }
  end

  describe 'instance methods' do
    it '.email_exists?' do
      user1 = build(:user, email: 'jun.lee@gmail.com')  
      expect(user1.email_exists?).to eq(false)

      user1.save
      user2 = build(:user, email: 'jun.lee@gmail.com')  
      expect(user2.email_exists?).to eq(true)
    end
  end
end
