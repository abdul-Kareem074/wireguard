# app/services/key_service.rb
# Service for generating WireGuard private and public keys
class KeyService
  # Generate a new private key using wg genkey
  def self.generate_private_key
    `wg genkey`.strip
  rescue => e
    Rails.logger.error "Failed to generate private key: #{e.message}"
    nil
  end

  # Generate public key from private key using wg pubkey
  def self.generate_public_key(private_key)
    return nil if private_key.blank?
    IO.popen('wg pubkey', 'r+') do |io|
      io.puts private_key
      io.close_write
      io.read.strip
    end
  rescue => e
    Rails.logger.error "Failed to generate public key: #{e.message}"
    nil
  end

  # Generate both private and public keys
  def self.generate_keypair
    private_key = generate_private_key
    return nil unless private_key

    public_key = generate_public_key(private_key)
    return nil unless public_key

    { private_key: private_key, public_key: public_key }
  rescue => e
    Rails.logger.error "Failed to generate keypair: #{e.message}"
    nil
  end
end