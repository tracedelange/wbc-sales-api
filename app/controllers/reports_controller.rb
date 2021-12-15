require 'csv'

class ReportsController < ApplicationController
  def index

    

  end

  def create

    #process new report
    if params[:distributer_id] && request.body

      distributer = Distributer.find_by(id: params[:distributer_id])
      report = CSV.parse(request.body, headers: true)

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

          #passing adjusted csv format for wbc reports. Headers behaving oddly.
          # wbcreport = CSV.parse(request.body)

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


  def process_wbc_report(input)



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

    input.each do |order|

      #For some reason the headers are being read into the bottom of the CSV table. Reader breaks when it tries to read nil values, this check below is to catch
      #the headers at the end of the loop.
      if order["Company"] == nil
        next
      end

      sale_date = Date.strptime(order[5].split(' ')[0], "%m/%d/%Y")
      if @last_wbc_order
        if sale_date <= @last_wbc_order
          next
        end
      end

      @account = Account.find_by(account_name: order[0])

      if !@account #account does not exist, create it.

        # if order['IsOffPremise'] == 'FALSE'
        # else
        #   on_premise = false
        # end
        on_premise = true


        @account = Account.create(
          account_name: order[0],
          distributer_id: 3,
          on_premise: on_premise,
          address: order[1],
          city: order[2],
          state: order[3]
        )

        if !@account.valid?
          next
        end
        
        stats = {**stats, "newAccounts" => stats["newAccounts"] + 1}
      end

      distributer_product = DistributerProduct.find_by(name: order[6])


      if !distributer_product
        distributer_product = DistributerProduct.create(name: order[6], distributer_id: 3)

        if !distributer_product.valid?
          next
        end

        @account.unknown_orders.create(sale_date: sale_date, distributer_product_id: distributer_product.id, distributer_id: 3)
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





  def process_locher_report(input)

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

    input.each do |order|
      # byebug;
      sale_date = Date.parse(order[0].split(' ')[0])

      if @last_locher_order
        if sale_date <= @last_locher_order
          pp "skipped"
          next
        end
      end

      # if order[1] == "BURKY'S BAR AND GRILL EFT"
        # byebug;
      # end

      @account = Account.find_by(account_name: order[1])

      if !@account #account does not exist, create it.

        if order[8] == 'FALSE'
          on_premise = true
        else
          on_premise = false
        end

        @account = Account.create(
          account_name: order[1],
          distributer_id: 2,
          on_premise: on_premise,
          address: order[2],
          city: order[3],
          state: order[4] 
        )

        if !@account.valid?
          next
        end

        stats = {**stats, "newAccounts" => stats["newAccounts"] + 1}
      end

      distributer_product = DistributerProduct.find_by(name: order[6])

      # pp distributer_product
      # pp @account
      # pp order

      if !distributer_product
        distributer_product = DistributerProduct.create(name: order[6], distributer_id: 2)

        if !distributer_product.valid?
          next
        end

        @account.unknown_orders.create(sale_date: sale_date, distributer_product_id: distributer_product.id, distributer_id: 2)
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

  def process_jj_report(input)

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

    input.each do |order|

      sale_date = Date.strptime(order[14].split(' ')[0], "%m/%d/%Y")

      if @last_jj_order
        if sale_date <= @last_jj_order
          next
        end
      end

      @account = Account.find_by(account_name: order[5])

      if !@account #account does not exist, create it.

        if order[4] == 'OnPremise'
          on_premise = true
        else
          on_premise = false
        end

        @account = Account.create(
          account_name: order[5],
          distributer_id: 1,
          on_premise: on_premise,
          address: order[2],
          city: order[0],
          state: order[1] 
        )
        if !@account.valid?
          next
        end
        
        stats = {**stats, "newAccounts" => stats["newAccounts"] + 1}
      end

      distributer_product = DistributerProduct.find_by(name: order[8])


      if !distributer_product
        distributer_product = DistributerProduct.create(name: order[8], distributer_id: 1)

        if !distributer_product.valid?
          next
        end

        @account.unknown_orders.create(sale_date: sale_date, distributer_product_id: distributer_product.id, distributer_id: 1)
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
