json.array!(@events) do |event|
  json.extract! event, :id, :name, :short_description, :description, :owner_id
  json.url event_url(event, format: :json)
end
