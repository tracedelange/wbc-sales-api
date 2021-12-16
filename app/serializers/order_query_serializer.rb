class OrderQuerySerializer < ActiveModel::Serializer
  attributes :id, :display_name, :account_name

  has_many :orders
  has_many :unknown_orders
end
