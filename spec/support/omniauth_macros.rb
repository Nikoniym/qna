module OmniauthMacros
  def mock_auth_hash(provider, email = nil)
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(
        provider: provider.to_s,
        uid: Devise.friendly_token.to_s,
        info: {
            email: email
        }
    )
  end
end