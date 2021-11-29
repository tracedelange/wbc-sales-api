class UpdateUnknownOrdersJob < ApplicationJob
  queue_as :default

  def perform(*args)

    # product_list = Product.pluck(:product_name)
    # jarow = FuzzyStringMatch::JaroWinkler.create( :pure )

    assignedOrderCount = 0

    UnknownOrder.all.each do |unknown_order|

      distributer_product = unknown_order.distributer_product

      if distributer_product.product_id

        product = distributer_product.product

        newOrder = Order.create(account_id: unknown_order.account_id, sale_date: unknown_order.sale_date, product_id: product.id)

        if newOrder.valid?
          assignedOrderCount += 1
          unknown_order.delete
        end
      end
      
      #create new order
      # selectedProduct = Product.find_by(product_name: productName)
      # Order.create(account_id: unknown_order.account_id, sale_date: unknown_order.sale_date, product_id: selectedProduct.id)
      # unknown_order.delete


    end

    puts assignedOrderCount

  end


end



# subjects = Subject.joins(:reviews).group('subjects.id').order('avg(reviews.rating) DESC')[@start, 10]