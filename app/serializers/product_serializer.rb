class ProductSerializer < ActiveModel::Serializer
  attributes :id, :product_name, :order_count, :account_count, :month_order_count, :six_month_order_count, :ytd_order_count

  has_many :distributer_products

  def month_order_count
    getSelf
    @product.orders.where(sale_date: (Time.now.midnight - 1.month)..Time.now.midnight ).count
  end
  
  def six_month_order_count
    getSelf
    @product.orders.where(sale_date: (Time.now.midnight - 6.month)..Time.now.midnight ).count
  end
  
  def ytd_order_count
    getSelf
    @product.orders.where(sale_date: (Time.now.beginning_of_year)..Time.now.midnight ).count
  end


  def order_count
    getSelf
    @product.orders.count
  end

  def account_count
    getSelf
    @product.orders.distinct.pluck(:account_id).count
  end

  private

  def getSelf
    @product = Product.find(self.object.id)
  end

end
