class Payment < ActiveRecord::Base
  require "active_merchant/billing/rails"

  attr_accessor :card_security_code
  attr_accessor :credit_card_number
  attr_accessor :expiration_month
  attr_accessor :expiration_year

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :card_security_code, presence: true
  validates :credit_card_number, presence: true
  validates :expiration_month, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }
  validates :expiration_year, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }

  validate :valid_card

  def credit_card
    ActiveMerchant::Billing::CreditCard.new(
      number:              credit_card_number,
      verification_value:  card_security_code,
      month:               expiration_month,
      year:                expiration_year,
      first_name:          first_name,
      last_name:           last_name
    )
  end

  def valid_card
    if !credit_card.valid?
      errors.add(:base, "The credit card information you provided is not valid.  Please double check the information you provided and then try again.")
      false
    else
      true
    end
  end

  def process(user)
    if valid_card
      transaction = ActiveMerchant::Billing::StripeGateway.new(:login => ENV["STRIPE_SECRET_KEY"])
      purchaseOptions = {:billing_address => {
	    :name     => user.name,
	    :address1 => user.address,
	    :city     => user.city,
	    :state    => user.state,
	    :zip      => user.zip
	  }}

	  response = transaction.purchase((amount * 100).to_i, credit_card, purchaseOptions)
      if response.success?
        update_columns({authorization_code: response.authorization, success: true})
        true
      else
        errors.add(:base, "The credit card you provided was declined.  Please double check your information and try again.") and return
        false
      end
    end
  end
end
