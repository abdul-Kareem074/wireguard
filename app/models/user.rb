class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Role-based access control
  enum role: { user: 0, admin: 1 }, _default: :user

  # Associations
  has_many :peers, dependent: :destroy

  # Methods
  def admin?
    role == 'admin'
  end
end
