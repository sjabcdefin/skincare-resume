json.extract! product, :id, :started_on, :name, :created_at, :updated_at
json.url product_url(product, format: :json)
