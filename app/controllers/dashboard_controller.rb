class DashboardController < ApplicationController
  def index
    @vpn_servers = VpnServer.all
    @peers = current_user.admin? ? Peer.all : current_user.peers
  end
end
