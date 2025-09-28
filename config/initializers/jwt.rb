# config/initializers/jwt.rb
# Provide a fallback secret in development only. In production use ENV or credentials.
JWT_SECRET_KEY = ENV["JWT_SECRET_KEY"] || Rails.application.credentials.dig(:secret_key_base) || "dev_secret_change_me_#{Rails.env}"
JWT_ALGORITHM = "HS256"
