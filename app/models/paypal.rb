require "net/https"
require "uri"
require 'cgi'

class Paypal

  ####################################################
  # Exceptions
  ####################################################

  class ConnectionError < StandardError; end
  class ArgumentError < StandardError; end


  ####################################################
  # Basic configuration
  ####################################################

  # Route definitions
  @@endpoint = URI.parse(PAYPAL[:routes][:endpoint])

  # Paypal credentials
  @@credentials = {
    :user      => PAYPAL[:credentials][:username],
    :pwd       => PAYPAL[:credentials][:password],
    :signature => PAYPAL[:credentials][:signature],
    :version   => '71.0'
  }


  ####################################################
  # Payment methods
  ####################################################

  # Initiating a transaction. Returns a hash containing
  # the transaction token used for further processing.
  #
  # _amount_::    String containing the transaction's amount. Must have two decimal places and
  #               decimal separator must be a period (.).
  # _currency_::  Three-letter currency code as symbol. Supported currencies are :usd, :eur, and :gbp
  def self.set_express_checkout(amount, currency, invoice_nr)
    raise Paypal::ArgumentError unless amount.present?
    raise Paypal::ArgumentError unless [:usd, :eur, :gbp].include?(currency)

    options = @@credentials.merge({
      :method       => 'SetExpressCheckout',
      :amt          => amount,
      :currencycode => currency.to_s.upcase,
      :invnum       => invoice_nr,
      :returnurl    => PAYPAL[:routes][:return_url],
      :cancelurl    => PAYPAL[:routes][:cancel_url],
      :notifyurl    => PAYPAL[:routes][:notify_url],
      :localecode   => 'US'
    })

    post_data(options)
  end

  # Retrieve the customer's shipping address and ID from paypal.
  #
  # _token_:: The transaction token received in the first API call.
  def self.get_express_checkout_details(token)
    raise Paypal::ArgumentError unless token.present?

    options = @@credentials.merge({
      :method     => 'GetExpressCheckoutDetails',
      :token      => token,
      :notifyurl  => PAYPAL[:routes][:notify_url]
    })

    post_data(options)
  end

  def self.do_express_checkout_payment(token, payer_id, amount, currency, paymentaction = 'Sale')
    raise Paypal::ArgumentError unless token.present?
    raise Paypal::ArgumentError unless payer_id.present?
    raise Paypal::ArgumentError unless amount.present?
    raise Paypal::ArgumentError unless [:usd, :eur, :gbp].include?(currency)

    options = @@credentials.merge({
      :method         => 'DoExpressCheckoutPayment',
      :token          => token,
      :payerid        => payer_id,
      :amt            => amount,
      :currencycode   => currency.to_s.upcase,
      :paymentaction  => paymentaction,
      :notifyurl      => PAYPAL[:routes][:notify_url]
    })

    post_data(options)
  end

  def self.validate_ipn(data)
    # Create http client
    uri = URI.parse(PAYPAL[:routes][:validate])
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    http.ca_file = "#{Rails.root}/config/cacert.pem"

    # Create the request
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data(data)

    # Perform request and return body
    response = http.request(request)
    response.body
  end


  private

    ####################################################
    # Connection and related
    ####################################################

    def self.post_data(data)
      # Create http client
      http = Net::HTTP.new(@@endpoint.host, @@endpoint.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      http.ca_file = "#{Rails.root}/config/cacert.pem"

      # Create the request
      request = Net::HTTP::Post.new(@@endpoint.request_uri)
      request.set_form_data(data)

      # Perform request, check for errors and return body
      response = http.request(request)
      check_response_for_errors_and_parse(response)
    end

    def self.check_response_for_errors_and_parse(response)
      # Check for any response code other than 200
      raise Paypal::ConnectionError unless response.code.to_i == 200

      # Parse response body
      body = parse_response_body(response.body)

      # Check for the ACK field
      raise Paypal::ConnectionError unless body[:ack] == 'Success' or body[:ack] == 'SuccessWithWarning'

      # Return parsed body
      return body
    end

    def self.parse_response_body(response_body)
      # Prepare body hash
      body = {}

      # Split parameters
      separated_params = response_body.split('&')

      # Split each combination in key and value and unescape
      separated_params.each do |param_combination|
        splitted  = param_combination.split('=')
        key       = CGI.unescape(splitted.first).downcase.to_sym
        value     = CGI.unescape(splitted.last)

        body[key] = value
      end

      # Return parse reponse body
      body
    end

end