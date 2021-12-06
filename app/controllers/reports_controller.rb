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
          results = process_locher_report(report)

          render json: {"processing_stats" => results}
          

        when 3
          #Process Self report

          results = process_wbc_report(report)
          render json: {"processing_stats" => results}
          
        end
        
        
      else
        
        render json: {"error" => "Either distributer does not exist or you did not provide a valid report."}, status: :unprocessable_entity
        
      end


    else
  
      render json: {'error' => 'We need a distributer ID to process the report under'}, status: :unprocessable_entity
    end

  end

  private


  def process_wbc_report(inputHash)


    stats = {"newAccounts" => 0, "assignedOrders" => 0, "unassignedOrders" => 0}

    # product_list = Product.pluck(:product_name)
    # jarow = FuzzyStringMatch::JaroWinkler.create( :pure )

    begin
      @last_wbc_order = Distributer.third.orders.order("sale_date DESC").take.sale_date
    rescue
      begin
        @last_wbc_order = Distributer.third.unknown_orders.order("sale_date DESC").take.sale_date
      rescue
        puts 'first time, no reference date'
      end
    end


    inputHash.each do |order|

      sale_date = Date.strptime(order['Delivery Date'].split(' ')[0], "%m/%d/%Y")
      if @last_wbc_order
        if sale_date <= @last_wbc_order
          next
        end
      end

      @account = Account.find_by(account_name: order["Compan"])

      if !@account #account does not exist, create it.

        # if order['IsOffPremise'] == 'FALSE'
        # else
        #   on_premise = false
        # end
        on_premise = true


        @account = Account.create(
          account_name: order["Company"],
          distributer_id: 3,
          on_premise: on_premise
        )
        stats = {**stats, "newAccounts" => stats["newAccounts"] + 1}
      end

      distributer_product = DistributerProduct.find_by(name: order['Item'])


      if !distributer_product
        distributer_product = DistributerProduct.create(name: order['Item'], distributer_id: 3)

        @account.unknown_orders.create(sale_date: sale_date, distributer_product_id: distributer_product.id)
        stats = {**stats, "unassignedOrders" => stats["unassignedOrders"] + 1}
      else
        if distributer_product.product_id
          
          @account.orders.create(sale_date: sale_date, product_id: distributer_product.product_id)
          stats = {**stats, "assignedOrders" => stats["assignedOrders"] + 1}
        else
          
          @account.unknown_orders.create(sale_date: sale_date, distributer_product_id: distributer_product.id, distributer_id: 3)
          stats = {**stats, "unassignedOrders" => stats["unassignedOrders"] + 1}
        end
      end

    end
    stats
  end





  def process_locher_report(inputHash)

    stats = {"newAccounts" => 0, "assignedOrders" => 0, "unassignedOrders" => 0}

    # product_list = Product.pluck(:product_name)
    # jarow = FuzzyStringMatch::JaroWinkler.create( :pure )

    begin
      @last_locher_order = Distributer.second.orders.order("sale_date DESC").take.sale_date
    rescue
      begin
        @last_locher_order = Distributer.second.unknown_orders.order("sale_date DESC").take.sale_date
      rescue
        puts 'first time, no reference date'
      end
    end

    inputHash.each do |order|
      # byebug;
      sale_date = Date.parse(order[order.keys.first].split(' ')[0])

      if @last_locher_order
        if sale_date <= @last_locher_order
          pp "skipped"
          next
        end
      end

      @account = Account.find_by(account_name: order["CusName"])

      if !@account #account does not exist, create it.

        if order['IsOffPremise'] == 'FALSE'
          on_premise = true
        else
          on_premise = false
        end

        @account = Account.create(
          account_name: order["CusName"],
          distributer_id: 2,
          on_premise: on_premise
        )
        stats = {**stats, "newAccounts" => stats["newAccounts"] + 1}
      end

      distributer_product = DistributerProduct.find_by(name: order['ItemName'])


      if !distributer_product
        distributer_product = DistributerProduct.create(name: order['ItemName'], distributer_id: 2)

        @account.unknown_orders.create(sale_date: sale_date, distributer_product_id: distributer_product.id)
        stats = {**stats, "unassignedOrders" => stats["unassignedOrders"] + 1}
      else
        if distributer_product.product_id
          
          @account.orders.create(sale_date: sale_date, product_id: distributer_product.product_id)
          stats = {**stats, "assignedOrders" => stats["assignedOrders"] + 1}
        else
          
          @account.unknown_orders.create(sale_date: sale_date, distributer_product_id: distributer_product.id, distributer_id: 2)
          stats = {**stats, "unassignedOrders" => stats["unassignedOrders"] + 1}
        end
      end

    end
    stats
  end

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

    begin
      @last_jj_order = Distributer.first.orders.order("sale_date DESC").take.sale_date
    rescue
      begin
        @last_jj_order = Distributer.first.unknown_orders.order("sale_date DESC").take.sale_date
      rescue
        puts 'first time, no reference date'
      end
    end

    inputHash.each do |order|

      sale_date = Date.strptime(order['SalesDate'].split(' ')[0], "%m/%d/%Y")

      if @last_jj_order
        if sale_date <= @last_jj_order
          next
        end
      end

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

      distributer_product = DistributerProduct.find_by(name: order['Brand'])


      if !distributer_product
        distributer_product = DistributerProduct.create(name: order['Brand'], distributer_id: 1)

        @account.unknown_orders.create(sale_date: sale_date, distributer_product_id: distributer_product.id)
        stats = {**stats, "unassignedOrders" => stats["unassignedOrders"] + 1}
      else
        if distributer_product.product_id
          
          @account.orders.create(sale_date: sale_date, product_id: distributer_product.product_id)
          stats = {**stats, "assignedOrders" => stats["assignedOrders"] + 1}
        else
          
          @account.unknown_orders.create(sale_date: sale_date, distributer_product_id: distributer_product.id, distributer_id: 1)
          stats = {**stats, "unassignedOrders" => stats["unassignedOrders"] + 1}
        end
      end

    end

    stats

  end


end
