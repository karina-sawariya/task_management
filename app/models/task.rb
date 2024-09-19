class Task < ApplicationRecord
  belongs_to :user
  enum status: { backlog: 'Backlog', in_progress: 'In-progress', done: 'Done' }

  validates :title, :description, :start_date, :end_date, :status, presence: true
  validate :end_date_after_start_date

  def end_date_after_start_date
    if end_date <= start_date
      errors.add(:end_date, "should be after the start date")
    end
  end
end
