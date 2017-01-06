json.extract! restaurant, :id, :name, :address, :phone1, :phone2, :note, :vegetarian, :created_at, :updated_at
json.url restaurant_url(restaurant, format: :json)