class OrderController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:recieve]

  def recieve
    headers['Access-Control-Allow-Origin'] = '*'

    puts params["shipping_address"]

    address_found = false
    free_trial_product = false

    for line_item in params["line_items"]
      if line_item["product_id"].to_s == ENV["PRODUCT_ID"]
        free_trial_product = true
      end
    end

    if free_trial_product
      puts Colorize.bright("Found Trial Product")

      total_orders = ShopifyAPI::Order.count(status: 'any')
      total_pages = (total_orders/250.0).ceil

      orders = ShopifyAPI::Order.find(:all, params: {limit: 250, status: 'any'})  
      address_found = compare_to_orders(orders)
    else
      puts Colorize.green("Not a Trial Product")
    end

    if address_found
      puts Colorize.red("Is a Duplicate, cancel it")

      order = ShopifyAPI::Order.find params["id"]
      order.cancel
    else
      puts Colorize.green("Is valid, all good!")
    end

    head :ok
  end

  def home

  end

  private

    def loop_orders(orders)
      for order in orders
        if order.shipping_address.address1 == params["shipping_address"]["address1"] and
        order.shipping_address.city == params["shipping_address"]["city"] and
        order.shipping_address.zip == params["shipping_address"]["zip"] and
        order.shipping_address.province == params["shipping_address"]["province"] and
        order.shipping_address.country == params["shipping_address"]["country"]
          return true
        end
      end

      return false
    end

    def compare_to_orders(orders)
      address_found = loop_orders(orders)
      if address_found
        return true
      end

      if orders.next_page?
        orders = orders.fetch_next_page
        compare_to_orders(orders)
      end

      return false
    end





end








































