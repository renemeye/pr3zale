json.array!(@products) do |product|
  json.extract! product, :id, :name, :price, :tax, :description, :quantity
  json.url product_url(product, format: :json)
end
