json.array!(@images) do |image|
  json.extract! image, :id, :image_file_name
  json.url image.image.url
  json.size image.image.size
end
