class OrderQuerySerializer < ActiveModel::Serializer
  attributes :id, :display_name, :account_name, :latitude, :longitude, :on_premise #, :unique_orders #, each_serialzer: OrderQueryItemSerializer

  # has_many :orders, serializer: OrderQueryItemSerializer, time_range: @instance_options[:time_range]

  has_many :unique_orders, serializer: OrderQueryItemSerializer

  def unique_orders

    time_range = @instance_options[:time_range]
    # account = Account.find(self.object.id)

    # account.orders.where(sale_date: time_range)
    # Order.from(
    #   Order.where(account_id: account.id, sale_date: time_range)
    #     .select('DISTINCT ON ("product_id") *')
    #     .order("product_id, created_at DESC"), 
    #     :orders
    # ).order(created_at: :desc)

    Order.where(sale_date: time_range, account_id: self.object.id)
    .select('DISTINCT ON ("product_id") *')
    .order('product_id, sale_date DESC')
    


  end


end
