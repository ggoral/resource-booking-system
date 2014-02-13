class Resource < ActiveRecord::Base
  has_many :bookings
  
  validates :name, presence: true

  def book(from, to, status = nil)
    book = bookings.between(from, to)
    book = book.where(status: status) if status
    book
  end

  def available?(from, to)
    book(from, to, 'pending').empty?
  end

end