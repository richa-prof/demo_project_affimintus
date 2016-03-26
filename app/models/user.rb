class User < ActiveRecord::Base
  
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true
  validates :address, presence: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
