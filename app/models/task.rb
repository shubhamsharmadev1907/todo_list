class Task < ApplicationRecord
  belongs_to :user, optional: true

  validates :title, presence: true, length: { maximum: 255 }
  validates :done, inclusion: { in: [true, false] }

  scope :incomplete, -> { where(done: false) }
  scope :recent, -> { order(created_at: :desc) }

  # Example of a small domain method
  def mark_done!
    update!(done: true)
  end
end
