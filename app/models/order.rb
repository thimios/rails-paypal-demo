class Order < ActiveRecord::Base

  # Mass-assignment protection
  attr_accessible :amount, :currency, :token, :payer_id, :address, :city, :country, :email, :first_name, :last_name, :postal_code, :state, :province, :terms_and_conditions

  # Virtual attributes
  attr_accessor :check_shipping_address, :terms_and_conditions

  # Validations
  validates :first_name,            :presence => true,    :if => :check_shipping_address?
  validates :last_name,             :presence => true,    :if => :check_shipping_address?
  validates :address,               :presence => true,    :if => :check_shipping_address?
  validates :city,                  :presence => true,    :if => :check_shipping_address?
  validates :country,               :presence => true,    :if => :check_shipping_address?
  validates :postal_code,           :presence => true,    :if => :check_shipping_address?
  validates :email,                 :presence => true,    :if => :check_shipping_address?
  validates :terms_and_conditions,  :acceptance => true,  :if => :check_shipping_address?

  # Scopes
  scope :active, lambda { |now|
    where('(orders.state = "pending" OR orders.state = "completed") OR (orders.state = "initiated" AND orders.updated_at > ?)', now - 20.minutes)
  }

  ####################################################
  # State machine config
  ####################################################

  state_machine :initial => :initiated do
    # Cancel order
    event :cancel do
      transition [:initiated, :pending, :completed] => :cancelled
    end

    # Complete the order
    event :complete do
      transition [:initiated, :pending] => :completed
    end

    # Pending order (waiting for payment notification)
    event :wait do
      transition [:initiated] => :pending
    end
  end


  ####################################################
  # Instance methods
  ####################################################

  def amount_as_string
    @amount_as_string ||= '%.2f' % self.amount
  end

  def check_shipping_address?
    @check_shipping_address || false
  end

end
