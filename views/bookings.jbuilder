# Place this file in the `views` directory.

json.bookings @bookings do |booking|
  json.from booking.start
  json.to booking.end
  json.status booking.status
  json.user booking.user
  
  json.links booking_links(booking) do |link|
    json.(link, :rel, :uri)
    if link[:method]
      json.(link, :method)
    end
  end
end

json.links bookings_links(@resources) do |link|
  json.(link, :rel, :uri)
end