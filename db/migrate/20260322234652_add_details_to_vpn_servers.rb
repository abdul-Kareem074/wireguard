class AddDetailsToVpnServers < ActiveRecord::Migration[7.0]
  def change
    add_column :vpn_servers, :encrypted_private_key, :text
    add_column :vpn_servers, :port, :integer, default: 51820
  end
end
