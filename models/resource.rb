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

  def approveds(from, to)
    book(from, to, 'approved').pluck(:start, :end).flatten
  end

  def periods_availables(from, to)
    arr = book(from, to, 'approved').pluck(:start, :end).flatten
    ([from] + arr.flatten + [to]).each_slice(2).to_a
  end

end