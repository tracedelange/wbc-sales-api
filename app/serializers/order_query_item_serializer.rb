class OrderQueryItemSerializer < ActiveModel::Serializer
  attributes :product_id, :sale_date #, :product_name


  def product_name
    Product.find(self.object.product_id).product_name
  end


end
