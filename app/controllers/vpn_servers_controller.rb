class VpnServersController < ApplicationController
  before_action :set_vpn_server, only: %i[show edit update destroy start stop]
  before_action :require_admin, only: %i[new create edit update destroy start stop]

  def index
    @vpn_servers = VpnServer.all
  end

  def show
  end

  def new
    @vpn_server = VpnServer.new
  end

  def create
    @vpn_server = VpnServer.new(vpn_server_params)
    if @vpn_server.save
      redirect_to @vpn_server, notice: 'VPN Server was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @vpn_server.update(vpn_server_params)
      redirect_to @vpn_server, notice: 'VPN Server was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @vpn_server.destroy
    redirect_to vpn_servers_url, notice: 'VPN Server was successfully destroyed.'
  end

  def start
    begin
      if WireguardService.start_interface(@vpn_server.interface_name)
        logger.info "Successfully started VPN server: #{@vpn_server.name} (#{@vpn_server.interface_name})"
        redirect_to @vpn_server, notice: 'VPN Server started successfully.'
      else
        logger.warn "Failed to start VPN server: #{@vpn_server.name} (#{@vpn_server.interface_name})"
        redirect_to @vpn_server, alert: 'Failed to start VPN Server. Ensure WireGuard is installed and sudo is configured. Check logs for details.'
      end
    rescue => e
      logger.error "Exception starting VPN server: #{e.class} - #{e.message}"
      redirect_to @vpn_server, alert: "Error: #{e.message}"
    end
  end

  def stop
    begin
      if WireguardService.stop_interface(@vpn_server.interface_name)
        logger.info "Successfully stopped VPN server: #{@vpn_server.name} (#{@vpn_server.interface_name})"
        redirect_to @vpn_server, notice: 'VPN Server stopped successfully.'
      else
        logger.warn "Failed to stop VPN server: #{@vpn_server.name} (#{@vpn_server.interface_name})"
        redirect_to @vpn_server, alert: 'Failed to stop VPN Server. Ensure WireGuard is installed and sudo is configured. Check logs for details.'
      end
    rescue => e
      logger.error "Exception stopping VPN server: #{e.class} - #{e.message}"
      redirect_to @vpn_server, alert: "Error: #{e.message}"
    end
  end

  private

  def set_vpn_server
    @vpn_server = VpnServer.find(params[:id])
  end

  def vpn_server_params
    params.require(:vpn_server).permit(:name, :public_ip, :interface_name, :public_key, :private_key, :port)
  end

  def require_admin
    redirect_to root_path, alert: 'Access denied.' unless current_user.admin?
  end
end
