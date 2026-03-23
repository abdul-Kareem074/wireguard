class PeersController < ApplicationController
  before_action :set_peer, only: %i[show edit update destroy generate_keys download_config]
  before_action :set_vpn_server, only: %i[index new create]

  def index
    if current_user.admin?
      @peers = @vpn_server ? @vpn_server.peers : Peer.all
    else
      @peers = @vpn_server ? @vpn_server.peers.where(user: current_user) : current_user.peers
    end
  end

  def show
  end

  def new
    @peer = Peer.new(vpn_server: @vpn_server, user: current_user)
  end

  def create
    @peer = Peer.new(peer_params)
    @peer.user = current_user unless current_user.admin?
    if @peer.save
      redirect_to @peer, notice: 'Peer was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @peer.update(peer_params)
      redirect_to @peer, notice: 'Peer was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @peer.destroy
    redirect_to peers_url, notice: 'Peer was successfully destroyed.'
  end

  def generate_keys
    keypair = KeyService.generate_keypair
    if keypair
      @peer.update(public_key: keypair[:public_key], private_key: keypair[:private_key])
      redirect_to @peer, notice: 'Keys generated successfully.'
    else
      redirect_to @peer, alert: 'Failed to generate keys. Please check that WireGuard tools are installed.'
    end
  end

  def download_config
    config = ConfigService.generate_client_config(@peer)
    send_data config, filename: "#{@peer.name}.conf", type: 'text/plain'
  end

  private

  def set_peer
    @peer = Peer.find(params[:id])
  end

  def set_vpn_server
    @vpn_server = VpnServer.find(params[:vpn_server_id]) if params[:vpn_server_id]
  end

  def peer_params
    permitted = [:name, :public_key, :private_key, :allowed_ips, :vpn_server_id]
    permitted << :user_id if current_user.admin?
    params.require(:peer).permit(*permitted)
  end
end
