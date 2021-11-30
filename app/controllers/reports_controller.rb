class ReportsController < ApplicationController
  def index

    

  end

  def create

    #process new report
    if params[:distributer_id] && request.body

      distributer = Distributer.find_by(id: params[:distributer_id])
      report = CsvHash.parse(request.body)

      if distributer && report.length > 0
        
        case distributer.id
          
        when 1
          #Process JJ report

          results = process_jj_report(report)

          render json: {"processing_stats" => results}, status: :accepted
          
        when 2

          #Process Locher Report
          render json: {"dis" => "Locher Bros"}
          
          s
        when 3
          #Process Self report
          render json: {"dis" => "WBC"}
          
        end
        
        
      else
        
        render json: {"error" => "Either distributer does not exist or you did not provide a valid report."}, status: :unprocessable_entity
        
      end


    else
  
      render json: {'error' => 'We need a distributer ID to process the report under'}, status: :unprocessable_entity
    end

  end

  private

  def process_jj_report(inputHash)


    #Sample jj order
    # {"ShipCity"=>"RED WING",
    #   "ShipState"=>"MN",
    #   "ShipAdr2"=>"3237 SOUTH SERVICE DRIVE",
    #   "ShipZip"=>"55066",
    #   "PremiseType"=>"OffPremise",
    #   "CusName"=>"MGM - RED WING - M0015",
    #   "MainDeliveryDriver"=>"Route 3030",
    #   "MainSalesPerson"=>"Andrew Pieper",
    #   "Brand"=>"Waconia Choc Pnut Butr Prtr",
    #   "FrontlinePrice"=>"46.15",
    #   "ItemKey"=>"11669441",
    #   "ItemName"=>"Waconia Choc Pnut Butr Prtr 6/4/16 C",
    #   "Package"=>"6/4/16 C",
    #   "PackName"=>"CB",
    #   "SalesDate"=>"11/12/2021 12:00:00 AM",
    #   "DateRange"=>"1/1 - 11/15/2021 [180SD]",
    #   "EquivCases"=>"1.3333",
    #   "Cases"=>"1",
    #   "Gallons"=>"3",
    #   "Barrels"=>"0.0968"}

    stats = {"newAccounts" => 0, "assignedOrders" => 0, "unassignedOrders" => 0}

    product_list = Product.pluck(:product_name)
    # jarow = FuzzyStringMatch::JaroWinkler.create( :pure )

    inputHash.each do |order|

      @account = Account.find_by(account_name: order["CusName"])

      if !@account #account does not exist, create it.

        if order['PremiseType'] == 'OnPremise'
          on_premise = true
        else
          on_premise = false
        end

        @account = Account.create(
          account_name: order["CusName"],
          distributer_id: 1,
          on_premise: on_premise
        )
        stats = {**stats, "newAccounts" => stats["newAccounts"] + 1}
      end

      # product_list = Product.pluck(:product_name)

      # productName = nil
      # distance = -1
      # trimmedBrand = order['Brand'].split(' ')[1..-1].join(' ')
      
      # product_list.each do |product_name|

      #   d = jarow.getDistance(trimmedBrand, product_name)
        
      #   if d > distance
      #     distance = d
      #     productName = product_name
      #   end
      # end

      # product = Product.find_by(product_name: productName)

      distributer_product = DistributerProduct.find_by(name: order['Brand'])

      if !distributer_product
        distributer_product = DistributerProduct.create(name: order['Brand'], distributer_id: 1)
        @account.unknown_orders.create(sale_date: order['SalesDate'].split(' ')[0], distributer_product_id: distributer_product.id)
        stats = {**stats, "unassignedOrders" => stats["unassignedOrders"] + 1}
      else
        if distributer_product.product_id
          @account.orders.create(sale_date: order['SalesDate'].split(' ')[0], product_id: distributer_product.product_id)
          stats = {**stats, "assignedOrders" => stats["assignedOrders"] + 1}
        else
          @account.unknown_orders.create(sale_date: order['SalesDate'].split(' ')[0], distributer_product_id: distributer_product.id, distributer_id: 1)
          stats = {**stats, "unassignedOrders" => stats["unassignedOrders"] + 1}
        end
      end




      # if distance > 0.75 #Create order
        # @account.orders.create(sale_date: order['SalesDate'].split(" ")[0], product_id: product.id)
        # stats = {**stats, "assignedOrders" => stats["assignedOrders"] + 1}
      # else #If product similarity is below 0.75, assign it to an unknown product later processing
        # @account.unknown_orders.create(sale_date: order['SalesDate'].split(" ")[0], product_name: order['Brand'].split(' ')[1..-1].join(' '))
        # stats = {**stats, "unassignedOrders" => stats["unassignedOrders"] + 1}
      # end
  end

  stats

  end

end
