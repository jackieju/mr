# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_mr_session',
  :secret      => 'c5f4e7b2e458e1670328182ce92c4673cbc4a4bdeea4a35e5e8e80abd5142494558f1b9f966fa025de90c06f9e32ee32e08ca4b49a70698dd563b3719cd58da9'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
