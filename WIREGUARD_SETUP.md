# WireGuard Setup & Troubleshooting Guide

## Overview
The WireGuard Dashboard application manages WireGuard VPN servers and peers. The `start` and `stop` actions for VPN servers require WireGuard tools to be installed on the system.

## Prerequisites

### On Linux (Production/Staging)
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install wireguard wireguard-tools

# Red Hat/CentOS
sudo dnf install wireguard-tools

# Verify installation
wg --version
wg-quick --version
```

### On Windows (Development)
**Note:** WireGuard on Windows doesn't support the `wg-quick` command line tool in the same way as Linux. You have several options:

#### Option 1: Use Windows Subsystem for Linux (WSL2) - Recommended
```powershell
# Enable WSL2
wsl --install

# Inside WSL Ubuntu terminal:
sudo apt-get update
sudo apt-get install wireguard wireguard-tools
```

#### Option 2: Install WireGuard for Windows
Visit [wireguard.com](https://www.wireguard.com/install/) and download the Windows installer. Note: Command-line tools work differently than Linux.

#### Option 3: Use Mock Mode for Development
Edit `config/environments/development.rb`:
```ruby
# Allow development/test mode without actual WireGuard system commands
config.wireguard_mock_mode = true
```

## Sudo Configuration

For the Rails application to start/stop WireGuard interfaces, sudo access may be required:

### Configure Passwordless Sudo (Linux)
```bash
# As root, edit sudoers file
sudo visudo

# Add these lines at the bottom:
# Allow www-data (Rails user) to run wg-quick without password
www-data ALL=(ALL) NOPASSWD: /usr/bin/wg-quick

# For development with your user account:
username ALL=(ALL) NOPASSWD: /usr/bin/wg-quick, /usr/bin/wg, /usr/bin/ip
```

## Common Errors and Solutions

### Error: "Failed to start VPN Server"

#### Cause 1: WireGuard Not Installed
**Solution:**
```bash
# Check if WireGuard is installed
which wg-quick
which wg

# If missing, install WireGuard (see Prerequisites section)
sudo apt-get install wireguard wireguard-tools
```

#### Cause 2: Sudo Permission Denied
**Symptoms:** Error message mentions "sudo: no password" or "permission denied"

**Solutions:**
- Configure passwordless sudo (see Sudo Configuration section above)
- Or run Rails application with sudo (not recommended for production)
- Or use WSL2 without sudo requirements

#### Cause 3: Invalid Interface Name
**Check the interface name in your VPN Server settings:**
```bash
# List available interfaces
ip link show
# or in Windows:
ipconfig
```

Update the interface name in the database to match available network interfaces.

#### Cause 4: Windows Development Environment
**On Windows without WSL:**
The application will fail to execute `wg-quick` commands because they're Unix-specific.

**Solution:**
1. Enable and use WSL2 (Option 1 above), OR
2. Deploy to a Linux server for testing VPN operations, OR
3. Enable mock mode for development (Option 3 above)

## Application Logging

Check logs for detailed error messages:

```bash
# View Rails development logs
tail -f log/development.log

# Or use PowerShell on Windows:
Get-Content log/development.log -Tail 50 -Wait
```

Look for entries like:
```
Failed to start WireGuard wg0: sudo: command not found
Exception starting WireGuard wg0: Errno::EACCES - Permission denied
```

## Testing the Configuration

### Verify WireGuard Installation
```bash
# Check WireGuard module is loaded (Linux)
lsmod | grep wireguard

# Or check interface status
ip link show

# Show public keys
wg show
```

### Test Interface Creation Manually
```bash
# Test if you can create/start an interface manually
sudo wg-quick up wg0

# If successful, you'll see interface details
ip addr show wg0

# Bring it down
sudo wg-quick down wg0
```

### Test from Rails Console
```bash
# Start Rails console
rails console

# Test WireGuard service
WireguardService.interface_up?('wg0')
WireguardService.get_status('wg0')

# Simulate starting an interface
WireguardService.start_interface('wg0')
```

## Development vs Production

### Development Environment
- **Database:** SQLite (file-based)
- **Server:** WEBrick (Rails local server)
- **WireGuard:** Optional - can use mock mode
- **Startup Command:** `rails s -u webrick -p 5000`

### Production Environment
- **Database:** PostgreSQL (recommended)
- **Server:** Puma + Nginx reverse proxy
- **WireGuard:** Required - must be installed and configured
- **Startup Command:** `bundle exec puma -c config/puma.rb`

## Configuration Files

### config/environments/development.rb
```ruby
# Add this for mock mode (development only)
config.wireguard_mock_mode = ENV['WIREGUARD_MOCK'] == 'true'
```

### Gemfile
```ruby
# Required gems for WireGuard integration
gem 'devise'           # Authentication
gem 'attr_encrypted'   # Private key encryption
gem 'rails'            # Framework
```

## Next Steps

1. **Verify Prerequisites:** Ensure WireGuard is installed on your system
2. **Configure Sudo:** Set up passwordless sudo if on Linux (production)
3. **Test Manually:** Run `sudo wg-quick up wg0` to verify basic functionality
4. **Check Logs:** Review `log/development.log` after attempting start/stop operations
5. **Deploy:** Once verified locally, deploy to production Linux server with WireGuard installed

## Support

For WireGuard-specific issues, visit: https://www.wireguard.com/
For Rails development questions: https://guides.rubyonrails.org/

---

**Last Updated:** March 2026
**Rails Version:** 7.0.10
**WireGuard Tools Version:** Latest stable
