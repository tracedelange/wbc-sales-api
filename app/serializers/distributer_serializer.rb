class DistributerSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :distributer_products
end
