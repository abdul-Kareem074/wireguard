# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create admin user
admin = User.find_or_create_by!(email: 'admin@example.com') do |u|
  u.password = 'password'
  u.role = :admin
end

# Create regular user
user = User.find_or_create_by!(email: 'user@example.com') do |u|
  u.password = 'password'
  u.role = :user
end

# Create VPN servers
server = VpnServer.find_or_create_by!(name: 'Test Server') do |s|
  s.public_ip = '1.2.3.4'
  s.interface_name = 'wg0'
  s.public_key = 'server_public_key_here'
  s.private_key = 'server_private_key_here'
  s.port = 51820
end

server_us = VpnServer.find_or_create_by!(name: 'US East Server') do |s|
  s.public_ip = '45.142.120.10'
  s.interface_name = 'wg1'
  s.public_key = 'us_east_public_key_12345'
  s.private_key = 'us_east_private_key_12345'
  s.port = 51821
end

server_eu = VpnServer.find_or_create_by!(name: 'EU West Server') do |s|
  s.public_ip = '185.190.40.50'
  s.interface_name = 'wg2'
  s.public_key = 'eu_west_public_key_67890'
  s.private_key = 'eu_west_private_key_67890'
  s.port = 51822
end

server_asia = VpnServer.find_or_create_by!(name: 'Asia Pacific Server') do |s|
  s.public_ip = '103.145.200.99'
  s.interface_name = 'wg3'
  s.public_key = 'asia_public_key_abcde'
  s.private_key = 'asia_private_key_abcde'
  s.port = 51823
end

# Create peers
Peer.find_or_create_by!(name: 'Admin Peer', vpn_server: server) do |p|
  p.public_key = 'admin_peer_public_key'
  p.private_key = 'admin_peer_private_key'
  p.allowed_ips = '10.0.0.2/32'
  p.user = admin
end

Peer.find_or_create_by!(name: 'User Peer', vpn_server: server) do |p|
  p.public_key = 'user_peer_public_key'
  p.private_key = 'user_peer_private_key'
  p.allowed_ips = '10.0.0.3/32'
  p.user = user
end

# Create peers for US East Server
Peer.find_or_create_by!(name: 'Admin US Peer', vpn_server: server_us) do |p|
  p.public_key = 'admin_us_peer_public_key'
  p.private_key = 'admin_us_peer_private_key'
  p.allowed_ips = '10.1.0.2/32'
  p.user = admin
end

Peer.find_or_create_by!(name: 'User US Peer', vpn_server: server_us) do |p|
  p.public_key = 'user_us_peer_public_key'
  p.private_key = 'user_us_peer_private_key'
  p.allowed_ips = '10.1.0.3/32'
  p.user = user
end

# Create peers for EU West Server
Peer.find_or_create_by!(name: 'Admin EU Peer', vpn_server: server_eu) do |p|
  p.public_key = 'admin_eu_peer_public_key'
  p.private_key = 'admin_eu_peer_private_key'
  p.allowed_ips = '10.2.0.2/32'
  p.user = admin
end

Peer.find_or_create_by!(name: 'User EU Peer', vpn_server: server_eu) do |p|
  p.public_key = 'user_eu_peer_public_key'
  p.private_key = 'user_eu_peer_private_key'
  p.allowed_ips = '10.2.0.3/32'
  p.user = user
end

# Create peers for Asia Pacific Server
Peer.find_or_create_by!(name: 'Admin Asia Peer', vpn_server: server_asia) do |p|
  p.public_key = 'admin_asia_peer_public_key'
  p.private_key = 'admin_asia_peer_private_key'
  p.allowed_ips = '10.3.0.2/32'
  p.user = admin
end

Peer.find_or_create_by!(name: 'User Asia Peer', vpn_server: server_asia) do |p|
  p.public_key = 'user_asia_peer_public_key'
  p.private_key = 'user_asia_peer_private_key'
  p.allowed_ips = '10.3.0.3/32'
  p.user = user
end

# Print seed summary
puts "\n=== Database Seed Summary ==="
puts "✅ Users: #{User.count}"
puts "✅ VPN Servers: #{VpnServer.count}"
puts "✅ Peers: #{Peer.count}"
puts "============================\n"
