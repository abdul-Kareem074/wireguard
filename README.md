# WireGuard VPN Dashboard

A comprehensive Rails application for managing WireGuard VPN servers and peers with a modern web interface.

## Features

- **User Authentication**: Devise-based authentication with admin/user roles
- **VPN Server Management**: CRUD operations for WireGuard servers
- **Peer Management**: Manage VPN peers with automatic key generation
- **Real-time Status**: Monitor server and interface status
- **Configuration Download**: Generate and download WireGuard client configs
- **Secure Key Management**: Encrypted private keys in database
- **Modern UI**: Clean, responsive web interface

## Setup

### Prerequisites

- Ruby 3.1.2
- Rails 7.0.10
- SQLite (for development)
- WireGuard tools (`wg`, `wg-quick`)

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   bundle install
   ```

3. Setup database:
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. Start the server:
   ```bash
   rails server
   ```

5. Visit `http://localhost:3000`

### Test Accounts

- **Admin**: `admin@example.com` / `password`
- **User**: `user@example.com` / `password`

## Architecture

### Models
- **User**: Devise authentication with roles
- **VpnServer**: Server configuration and keys
- **Peer**: Client configurations linked to servers

### Services
- **KeyService**: WireGuard key generation
- **WireguardService**: Interface management
- **ConfigService**: Client config generation

### Controllers
- **DashboardController**: Main dashboard
- **VpnServersController**: Server management
- **PeersController**: Peer management

## Security

- Private keys encrypted in database
- Role-based access control
- CSRF protection
- Input validation

## API Endpoints

- `GET /health` - Health check
- Standard RESTful routes for all resources

## Development

The application uses:
- **Rails 7** with Hotwire/Stimulus
- **SQLite** for development database
- **WEBrick** for development server
- **Devise** for authentication
- **Bootstrap-inspired** CSS for styling

## Production Deployment

For production deployment:
1. Use PostgreSQL database
2. Set proper environment variables
3. Configure proper web server (Puma/Nginx)
4. Set up background job processing (Sidekiq)
5. Configure SSL certificates

## License

This project is open source and available under the MIT License.
