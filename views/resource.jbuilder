# Place this file in the `views` directory.

json.resource do |json|
  json.(@resource, :name, :description)

  json.links resource_links(@resource) do |link|
    json.(link, :rel, :uri)
  end
end
