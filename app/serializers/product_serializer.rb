class ProductSerializer < ActiveModel::Serializer
  attributes :id, :product_name, :order_count, :account_count, :month_order_count, :six_month_order_count, :ytd_order_count, :order_percentage_of_total #, :graph_orders

  has_many :distributer_products

  def six_month_order_count
    getSelf
    @product.orders.where(sale_date: (Time.now.midnight - 6.month)..Time.now.midnight ).count
  end
  
  def month_order_count
    getSelf
    @product.orders.where(sale_date: (Time.now.midnight - 1.month)..Time.now.midnight ).count
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

  def order_percentage_of_total
    getSelf
    (Float(@product.orders.count) / Float(Order.all.count) * 100).round(2)
  end

  def graph_orders
    getSelf
    @orders = Order.where(product_id: @product.id).group('sale_date').order('sale_date ASC').count

    result = {}
    (@orders.first[0]..Date.today()).each do |date|
      # Do stuff with date
      # byebug;
      if @orders[date] != nil
        result[date] = @orders[date]
      else 
        result[date] = 0
      end
    end

    result

  end

  private

  def getSelf
    @product = Product.find(self.object.id)
  end

end
