class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include CanCan::ControllerAdditions

  before_action :set_default_format
  before_action :authenticate_request!

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
  rescue_from CanCan::AccessDenied, with: :render_forbidden
  rescue_from JWT::DecodeError, with: :render_unauthorized
  rescue_from JWT::ExpiredSignature, with: :render_unauthorized

  private

  def set_default_format
    request.format = :json
  end

  # ---------- Authentication ----------
  # Reads Authorization: Bearer <token>
  def authenticate_request!
    header = request.headers["Authorization"]
    if header.present? && header.match?(/^Bearer /)
      token = header.split(" ").last
      begin
        decoded = JWT.decode(token, JWT_SECRET_KEY, true, algorithm: JWT_ALGORITHM).first
        @current_user = User.find(decoded["sub"])
      rescue JWT::ExpiredSignature
        return render json: { error: "Token has expired" }, status: :unauthorized
      rescue JWT::DecodeError => e
        return render json: { error: "Invalid token: #{e.message}" }, status: :unauthorized
      end
    else
      return render json: { error: "Missing Authorization header" }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end
  helper_method :current_user if respond_to?(:helper_method)

  # ---------- Error responses ----------
  def render_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def render_unprocessable_entity(exception)
    render json: { error: exception.record.errors.full_messages }, status: :unprocessable_entity
  end

  def render_forbidden(exception)
    render json: { error: exception.message || "Access denied" }, status: :forbidden
  end

  def render_unauthorized(exception = nil)
    message = exception&.message || "Unauthorized"
    render json: { error: message }, status: :unauthorized
  end
end
