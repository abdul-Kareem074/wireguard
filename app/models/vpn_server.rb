class VpnServer < ApplicationRecord
  has_many :peers, dependent: :destroy

  # Encrypt private key in database
  attr_encrypted :private_key, key: Rails.application.secret_key_base[0..31]

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :public_ip, presence: true
  validates :interface_name, presence: true
  validates :public_key, presence: true
  validates :port, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 65536 }
end
