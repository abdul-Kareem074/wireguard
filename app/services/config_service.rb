# app/services/config_service.rb
# Service for generating WireGuard configuration files
class ConfigService
  # Generate client config for a peer
  def self.generate_client_config(peer)
    server = peer.vpn_server

    config = <<~CONFIG
      [Interface]
      PrivateKey = #{peer.private_key}
      Address = #{peer.allowed_ips}
      DNS = 8.8.8.8

      [Peer]
      PublicKey = #{server.public_key}
      Endpoint = #{server.public_ip}:#{server.port}
      AllowedIPs = 0.0.0.0/0
      PersistentKeepalive = 25
    CONFIG

    config
  end

  # Note: Server public_key should be stored in VpnServer model
  # For server config, would need server private key, etc., but for client download
end