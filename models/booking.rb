class Booking < ActiveRecord::Base
  belongs_to :resource
#  belongs_to :user

  before_validation :set_pending_status, on: :create

  validates :resource, :start, :end, presence: true
  validates :status, inclusion: ["pending", "approved"]

  protected
  def set_pending_status
    self.status = "pending"
  end
end