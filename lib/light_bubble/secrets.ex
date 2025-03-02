defmodule LightBubble.Secrets do
  use AshAuthentication.Secret

  def secret_for([:authentication, :tokens, :signing_secret], LightBubble.Accounts.User, _opts) do
    Application.fetch_env(:light_bubble, :token_signing_secret)
  end
end
