# Place this file in the `views` directory.
 
json.resources @resources do |resource|
  json.(resource, :name, :description)

  json.links resource_links(resource) do |link|
    json.(link, :rel, :uri)
  end
end

json.links resources_links(@resources) do |link|
  json.(link, :rel, :uri)
end