defmodule LightBubble.Accounts do
  use Ash.Domain, otp_app: :light_bubble, extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource LightBubble.Accounts.Token
    resource LightBubble.Accounts.User
  end
end
