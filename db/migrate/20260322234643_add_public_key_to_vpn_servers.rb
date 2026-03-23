class AddPublicKeyToVpnServers < ActiveRecord::Migration[7.0]
  def change
    add_column :vpn_servers, :public_key, :text
  end
end
