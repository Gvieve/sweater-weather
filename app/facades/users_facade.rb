class UsersFacade

  def self.create_user(params)
    return nil if !required.all? {|key| params.has_key? key }
    User.create!(user_params(params))
  end

  private

  def self.required
    [:email, :password, :password_confirmation]
  end

  def self.user_params(params)
    params[:email] = params[:email].downcase
    params.permit(:email, :password, :password_confirmation)
  end
end
