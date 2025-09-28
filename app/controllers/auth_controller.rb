class AuthController < ApplicationController
  # Signup does not require authentication
  skip_before_action :authenticate_request!, only: %i[signup login]

  # POST /auth/signup
  def signup
    user = User.new(signup_params)
    user.role = "user" # default role for signup
    user.save!
    token = user.generate_jwt
    render json: { token: token, user: { id: user.id, email: user.email, role: user.role } }, status: :created
  end

  # POST /auth/login
  def login
    user = User.find_by(email: login_params[:email])
    if user&.authenticate(login_params[:password])
      token = user.generate_jwt
      render json: { token: token, user: { id: user.id, email: user.email, role: user.role } }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  private

  def signup_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def login_params
    params.require(:user).permit(:email, :password)
  end
end
