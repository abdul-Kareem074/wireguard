class CreateVpnServers < ActiveRecord::Migration[7.0]
  def change
    create_table :vpn_servers do |t|
      t.string :name
      t.string :public_ip
      t.string :interface_name

      t.timestamps
    end
  end
end
