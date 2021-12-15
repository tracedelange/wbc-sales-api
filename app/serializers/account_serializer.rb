class AccountSerializer < ActiveModel::Serializer
  attributes :id, :on_premise, :display_name, :account_name, :address, :city, :state, :latitude, :longitude, :hidden, :ytd_order_count, :month_order_count



  def month_order_count
    getSelf
    order_count = @account.orders.where(sale_date: (Time.now.midnight - 1.month)..Time.now.midnight ).count 
    unknown_order_count = @account.unknown_orders.where(sale_date: (Time.now.midnight - 1.month)..Time.now.midnight ).count

    order_count + unknown_order_count
  end

  def ytd_order_count
    getSelf
    order_count = @account.orders.where(sale_date: (Time.now.beginning_of_year)..Time.now.midnight ).count
    unknown_order_count = @account.unknown_orders.where(sale_date: (Time.now.beginning_of_year)..Time.now.midnight ).count

    order_count + unknown_order_count
  end

  private

  def getSelf
    @account = Account.find(self.object.id)
  end


end
