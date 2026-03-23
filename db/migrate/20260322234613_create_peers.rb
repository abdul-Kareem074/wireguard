class CreatePeers < ActiveRecord::Migration[7.0]
  def change
    create_table :peers do |t|
      t.string :name
      t.text :public_key
      t.text :encrypted_private_key
      t.string :allowed_ips
      t.references :vpn_server, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
