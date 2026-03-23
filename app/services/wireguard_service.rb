# app/services/wireguard_service.rb
# Service for managing WireGuard interfaces
class WireguardService
  # Start WireGuard interface
  def self.start_interface(interface_name)
    begin
      output = `sudo wg-quick up #{interface_name} 2>&1`
      success = $?.success?
      
      if success
        Rails.logger.info "Successfully started WireGuard interface #{interface_name}"
      else
        Rails.logger.error "Failed to start WireGuard #{interface_name}: #{output}"
      end
      
      success
    rescue => e
      Rails.logger.error "Exception starting WireGuard #{interface_name}: #{e.class} - #{e.message}\n#{e.backtrace.join('\n')}"
      false
    end
  end

  # Stop WireGuard interface
  def self.stop_interface(interface_name)
    begin
      output = `sudo wg-quick down #{interface_name} 2>&1`
      success = $?.success?
      
      if success
        Rails.logger.info "Successfully stopped WireGuard interface #{interface_name}"
      else
        Rails.logger.error "Failed to stop WireGuard #{interface_name}: #{output}"
      end
      
      success
    rescue => e
      Rails.logger.error "Exception stopping WireGuard #{interface_name}: #{e.class} - #{e.message}\n#{e.backtrace.join('\n')}"
      false
    end
  end

  # Restart WireGuard interface
  def self.restart_interface(interface_name)
    stop_interface(interface_name) && start_interface(interface_name)
  end

  # Get status of WireGuard interface
  def self.get_status(interface_name)
    `sudo wg show #{interface_name} 2>/dev/null`.strip
  rescue => e
    Rails.logger.warn "Could not get WireGuard status for #{interface_name}: #{e.message}"
    ""
  end

  # Check if interface is up
  def self.interface_up?(interface_name)
    begin
      `ip link show #{interface_name} 2>/dev/null | grep -q 'UP'`
      success = $?.success?
      success
    rescue => e
      Rails.logger.warn "Could not check interface status for #{interface_name}: #{e.message}"
      false
    end
  end
end