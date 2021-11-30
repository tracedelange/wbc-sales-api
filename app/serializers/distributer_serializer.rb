class DistributerSerializer < ActiveModel::Serializer
  attributes :id, :name, :unassigned_products
  # has_many :distributer_products

  def unassigned_products

    DistributerProduct.where(product_id: nil, distributer_id: self.object.id)


  end

end
