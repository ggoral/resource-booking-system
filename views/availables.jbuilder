# Place this file in the `views` directory.

json.availables @availables do |available|
  json.from available.first
  json.to available.last

  json.links available_links(@available_resource_id) do |link|
    json.(link, :rel, :uri)
    if link[:method]
      json.(link, :method)
    end
  end
end

json.links availables_links do |link|
  json.(link, :rel, :uri)
end
