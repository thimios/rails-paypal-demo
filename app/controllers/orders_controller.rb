require 'cgi'

class OrdersController < ApplicationController

  before_filter :check_for_valid_currency, :only => :create
  before_filter :fetch_order_and_check_for_timeout, :only => [:confirm, :update]

  def create
    ticket = Ticket.find(params[:id])

    # Create order object
    @order = Order.create({
      :amount => ticket.unit_price,
      :currency => params[:currency]
    })


    # Initiate transaction and update order object
    token = Paypal.set_express_checkout(@order.amount_as_string, @order.currency.to_sym, @order.id)[:token]
    @order.update_attributes({:token => token})

    # Redirect to Paypal
    redirect_to PAYPAL[:routes][:redirect] + "&token=#{CGI.escape(token)}"
  end

  def confirm
    # Save payer ID
    @order.update_attributes({ :payer_id => params[:PayerID] })

    # Get checkout details and save to order object
    @order.update_attributes( preprocess_details(Paypal.get_express_checkout_details(@order.token)) )
  end

  def update
    # Update order
    @order.check_shipping_address = true
    @order.attributes = params[:order]
    if @order.valid?
      @order.save

      # Finish transaction
      Paypal.do_express_checkout_payment(@order.token, @order.payer_id, @order.amount_as_string, @order.currency.to_sym)

      redirect_to thank_you_path
    else
      render :confirm
    end
  end

  def cancel
    # Update order
    @order = Order.find_by_token(params[:token])
    @order.cancel

    redirect_to root_path, :alert => "Order cancelled."
  end

  def ipn
    Rails.logger.info "ipn received"
    # Validate ipn request
    code = Paypal.validate_ipn(params)

    # Check response code
    if code == "VERIFIED"
      # Payment status complete?
      if params[:payment_status] == 'Completed'
        # Check for non duplicate transaction ID
        unless Order.find_by_txn_id(params[:txn_id]).present?
          # Receiver email correct?
          if params[:receiver_email] == PAYPAL[:credentials][:receiver_email]
            # Fetch order
            order = Order.find_by_id(params[:invoice])

            # Check correct parameters
            if order.currency == params[:mc_currency].downcase and order.amount == Float(params[:mc_gross]) and order.payer_id == params[:payer_id]

               order.complete
               order.update_attributes({:txn_id => params[:txn_id]})
            end
          end
        end
      elsif params[:payment_status] == 'Pending'
        # Fetch order and set to pending state
        order = Order.find_by_id(params[:invoice])
        order.wait
      else
        # Fetch order and cancel
        order = Order.find_by_id(params[:invoice])
        order.cancel
      end
    else
      Rails.logger.fatal "Failed to verify IPN request."
    end

    head '200'
  end


  private

    def check_for_valid_currency
      params[:currency] = params[:currency] || :eur
      redirect_to root_path unless [:eur, :gbp, :usd].include?(params[:currency].to_sym)
    end

    def preprocess_details(details)
      cleaned_details = {}
      cleaned_details[:first_name]  = details[:firstname]
      cleaned_details[:last_name]   = details[:lastname]
      cleaned_details[:address]     = details[:shiptostreet]
      cleaned_details[:city]        = details[:shiptocity]
      cleaned_details[:province]    = details[:shiptostate] == "Empty" ? "" : details[:shiptostate]
      cleaned_details[:country]     = details[:shiptocountryname]
      cleaned_details[:postal_code] = details[:shiptozip]
      cleaned_details[:email]       = details[:email]

      cleaned_details
    end

    def fetch_order_and_check_for_timeout
      @order = Order.find_by_token(params[:token])

      redirect_to(root_path, :alert => "Your session timed out. Please start again.") if @order.updated_at < (Time.now - 20.minutes)
    end

end
