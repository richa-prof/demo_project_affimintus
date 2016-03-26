class PaymentsController < ApplicationController
  before_action :authenticate_user!

  def index
	@payments = Payment.all  
  end

  def new
  	@payment = Payment.new
  end

  def create
  	@payment = Payment.new(payment_params)
    if @payment.save
      if @payment.process(current_user)
        redirect_to payments_path, notice: "The user has been successfully charged." and return
      end
    else
      redirect_to new_payment_path, notice: "Something went wrong please try again."
    end
    
  end

  private
  def payment_params
    params.require(:payment).permit(:first_name, :last_name, :credit_card_number, :expiration_month, :expiration_year, :card_security_code, :amount)
  end
end
