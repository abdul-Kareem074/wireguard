class Peer < ApplicationRecord
  belongs_to :vpn_server
  belongs_to :user

  # Encrypt private key in database
  attr_encrypted :private_key, key: Rails.application.secret_key_base[0..31]

  # Validations
  validates :name, presence: true
  validates :public_key, presence: true
  validates :allowed_ips, presence: true
end
