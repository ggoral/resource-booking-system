# Place this file in the `views` directory.

json.from @booking.start
json.to @booking.end
json.status @booking.status

json.links booking_links(@booking) do |link|
  json.(link, :rel, :uri)
  if link[:method]
  json.(link, :method)
  end
end
