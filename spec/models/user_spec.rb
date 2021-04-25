require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it {should validate_presence_of :email}
    it {should validate_presence_of :password}
    it {should validate_uniqueness_of(:email).on(:create)}
  end

  describe "email format" do
    it "create a user with a valid email format" do
      user = User.create!(email: 'jordiebear@email.com', password: 'littleone')

      expect(user.email).to eq('jordiebear@email.com')
    end

    it "should not create a user with a invalid email format" do
      user = User.new(email: 'jordiebear', password: 'littleone')

      expect(user.save).to eq(false)
    end
  end

  describe 'instance methods' do
    describe '#set_api_key' do
      it "sets the api_key value on valid user when created" do
        user = User.create!(email: 'jordiebear@email.com', password: 'littleone')
        
        expect(user.api_key).to be_a(String)
        expect(user.api_key.length).to eq(28)
      end
    end
  end
end
