class ProductSerializer < ActiveModel::Serializer
  attributes :id, :product_name, :order_count

  has_many :distributer_products

  def order_count
    Product.find(self.object.id).orders.count
  end
end
