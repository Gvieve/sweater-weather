class SessionsFacade

  def self.authenticate_user(params)
    return 'invalid' if !params[:email] || !params[:password]
    user = User.find_by(email: params[:email].downcase)
    user if user && user.authenticate(params[:password])
  end
end
