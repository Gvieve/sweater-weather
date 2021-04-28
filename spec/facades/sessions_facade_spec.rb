require 'rails_helper'

describe UsersFacade do
  describe 'happy path' do
    it "called Facade and got the user with valid parameters" do
      params = ActionController::Parameters.new({ email: 'jordiebear@email.com', password: 'littleone', password_confirmation: 'littleone' })
      result = UsersFacade.create_user(params)

      user = User.last

      expect(result).to be_a(User)
      expect(user.email).to eq(params[:email])
      expect(user.password_digest).to_not be_nil
      expect(user.api_key.length).to eq(28)
    end
  end
end
