helpers do

  def base_url
    @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
  end

  def options_path(path, resource_id = ':resource_id', booking_id = ':booking_id')
    hash_path = {
      "resources" => "#{base_url}/resources",
      "resource" => "#{base_url}/resources/#{resource_id}",
      "resource_bookings" => "#{base_url}/resources/#{resource_id}/bookings",
      "resource_availability" => "#{base_url}/resources/#{resource_id}/bookings",
      "resource_booking" => "#{base_url}/resources/#{resource_id}/bookings/#{booking_id}",
    }
    hash_path[path]
  end

  def link_path(path, rel=:self, method=nil)
    link = {
      rel: rel, 
      uri: url(path)
      }
    if method then
      link[:method] = method  
    end
    link
  end

  def resource_links(resource)
    links = [] << link_path(options_path("resource",resource.id))
    links << link_path(options_path("resource_bookings",resource.id),:bookings)
    links
  end

  def resources_links(resources)
    links = [] << link_path(options_path("resources"))
    links
  end

  def booking_links(booking)
    links = [] 
    links << link_path(options_path("resource_booking", booking.resource_id, booking.id))
    links << link_path(options_path("resource", booking.resource_id), :resource)
    links << link_path(options_path("resource_booking", booking.resource_id, booking.id), :accept, 'PUT')
    links << link_path(options_path("resource_booking", booking.resource_id, booking.id), :reject, 'DELETE')
    links
  end

  def bookings_links(bookings)
    links = [] << link_path(request.url)
    #ActiveSupport::JSON::Encoding.escape_html_entities_in_json = true
    cadena = "&"
    puts cadena.to_json
    #cadena = html_escapes(cadena)
    #puts cadena.to_json
    links
  end
  
end