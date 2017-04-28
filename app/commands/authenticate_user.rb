class AuthenticateUser
  prepend SimpleCommand


  def initialize(email, password)
    @email = email
    @password = password
  end

  def call
    JsonWebToken.encode(payload(user)) if user
  end

  private

  attr_accessor :email, :password

  def user
    user = User.find_for_database_authentication(email: email)
    return user if user && user.valid_password?(password)
    errors.add :user_authentication, 'invalid credentials'
    nil
  end

  def payload(user)
    {user_id: user.id}
  end
end