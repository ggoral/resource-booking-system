# Place this file in the `views` directory.

json.availables @availables do |available|
  json.from available.start
  json.to available.end

  json.links available_links(available) do |link|
    json.(link, :rel, :uri)
    if link[:method]
      json.(link, :method)
    end
  end
end

json.links available_links(@availables) do |link|
  json.(link, :rel, :uri)
end
