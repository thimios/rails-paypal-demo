# Does config exist?
raise 'No Paypal API config specified. Please create /config/paypal.yml!' unless File.exist?("#{Rails.root}/config/paypal.yml")

# Read config
config_file = File.read("#{Rails.root}/config/paypal.yml")
PAYPAL      = YAML.load(config_file)[Rails.env]["paypal"].deep_symbolize_keys


# Configure Koala and Twitter Gems