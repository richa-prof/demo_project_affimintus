class RegistrationsController < Devise::RegistrationsController

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :city, :state, :zip, :address)
  end

  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :city, :state, :zip, :address, :current_password)
  end
end