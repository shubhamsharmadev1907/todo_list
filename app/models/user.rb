class User < ApplicationRecord
  has_secure_password

  has_many :tasks, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true, inclusion: { in: %w[user admin] }

  # Convenience: generate a JWT for the user
  def generate_jwt(exp: 24.hours.from_now)
    payload = { sub: id, exp: exp.to_i, role: role }
    JWT.encode(payload, JWT_SECRET_KEY, JWT_ALGORITHM)
  end

  def admin?
    role == "admin"
  end
end
