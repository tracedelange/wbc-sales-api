class OrderSerializer < ActiveModel::Serializer
  attributes :id, :sale_date, :product_id
end
