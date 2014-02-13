class Booking < ActiveRecord::Base
  belongs_to :resource

  before_validation :set_pending_status, on: :create

  validates :resource, :start, :end, presence: true
  validates :status, inclusion: ["pending", "approved"]

  scope :between, -> (from, to) { where("start >= ? AND end <= ?", from, to) }
    
  protected
  def set_pending_status
    self.status = "pending"
  end
end