# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_microblogging_session',
  :secret      => 'e7c78275b7a231ba4f34e6a27e39f55be713ba3d3281b652e4a94bd524d9fb6b9cd7648dccb8381789e83f9590806d499aeeca6eef32dca2e549aafa5c5ded68'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
