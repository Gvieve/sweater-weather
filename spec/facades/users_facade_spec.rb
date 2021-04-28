require 'rails_helper'

describe SessionsFacade do
  describe 'happy path' do
    it "called Facade and got the session for a valid user" do
      user1 = User.create!(email: 'jordiebear@email.com', password: 'littleone', password_confirmation: 'littleone')
      params = { email: user1.email,
                password: 'littleone' }
      result = SessionsFacade.authenticate_user(params)

      expect(result).to be_a(User)
      expect(result).to eq(user1)
    end
  end
end
