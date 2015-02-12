json.array!(@cooperators) do |cooperator|
  json.extract! cooperator, :id, :user_id, :event_id, :nickname, :role
  json.url cooperator_url(cooperator, format: :json)
end
