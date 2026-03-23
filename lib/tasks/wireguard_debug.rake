# lib/tasks/wireguard_debug.rake

namespace :wireguard do
  desc "Check WireGuard installation and configuration"
  task check: :environment do
    puts "\n" + "=" * 60
    puts "WireGuard Configuration Check"
    puts "=" * 60 + "\n"

    # Check for WireGuard commands
    %w[wg wg-quick ip].each do |cmd|
      path = `which #{cmd} 2>/dev/null`.strip
      status = path.empty? ? "❌ NOT FOUND" : "✅ FOUND at #{path}"
      puts "#{cmd.ljust(15)} #{status}"
    end

    puts "\n" + "-" * 60
    puts "Network Interfaces"
    puts "-" * 60 + "\n"
    
    # List interfaces
    system("ip link show") || puts("ip command not available on this system")

    puts "\n" + "-" * 60
    puts "WireGuard Servers in Database"
    puts "-" * 60 + "\n"

    VpnServer.all.each do |server|
      puts "Server: #{server.name}"
      puts "  Interface: #{server.interface_name}"
      puts "  IP: #{server.public_ip}"
      puts "  Port: #{server.port}"
      puts "  Peers: #{server.peers.count}"
      puts ""
    end

    puts "-" * 60
    puts "Testing WireGuard Service"
    puts "-" * 60 + "\n"

    server = VpnServer.first
    if server
      interface = server.interface_name
      puts "Testing with interface: #{interface}\n"
      
      puts "1. Checking if interface is up..."
      up = WireguardService.interface_up?(interface)
      puts "   Result: #{up ? '✅ UP' : '❌ DOWN'}\n"
      
      puts "2. Getting status..."
      status = WireguardService.get_status(interface)
      puts "   Status present: #{status.empty? ? '❌ Empty' : '✅ Available'}\n"
      
      puts "3. View full Rails logs:"
      puts "   File: log/development.log\n"
    else
      puts "⚠️  No VPN servers found in database. Run: rails db:seed\n"
    end

    puts "\n" + "=" * 60
  end

  desc "View recent WireGuard errors in Rails log"
  task log_errors: :environment do
    log_file = "log/development.log"
    
    unless File.exist?(log_file)
      puts "Log file not found: #{log_file}"
      return
    end

    puts "\n" + "=" * 60
    puts "Recent WireGuard Errors (Last 50 lines containing 'wg' or 'WireGuard')"
    puts "=" * 60 + "\n"

    lines = File.readlines(log_file).reverse
    matched = lines.select { |l| l.downcase.include?('wireguard') || l.include?('wg') }
                   .first(50)
                   .reverse

    if matched.empty?
      puts "No WireGuard-related log entries found."
    else
      matched.each { |line| puts line }
    end

    puts "\n" + "=" * 60 + "\n"
  end

  desc "Clear old log files"
  task clear_logs: :environment do
    log_file = "log/development.log"
    if File.exist?(log_file)
      File.open(log_file, 'w') { |f| f.truncate(0) }
      puts "✅ Cleared #{log_file}"
    end
  end

  desc "Simulate starting a VPN server (for testing)"
  task :start_test, [:interface_name] => :environment do |t, args|
    interface = args[:interface_name] || "wg0"
    puts "\nSimulating start of interface: #{interface}\n"
    result = WireguardService.start_interface(interface)
    puts "Result: #{result ? '✅ Success' : '❌ Failed'}"
    puts "\nCheck log/development.log for details.\n"
  end
end
