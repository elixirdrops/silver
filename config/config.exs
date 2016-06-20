# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
#     config :silver, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:silver, :key)
#
# Or configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"

config :silver, :stripe,
  gateway: Silver.Gateway.Stripe,
  api_key: "sk_test_BQokikJOvBiI2HlWgH4olfQ2",
  secret: "",
  currency: "USD"

config :silver, :paypal,
  gateway: Silver.Gateway.Paypal,
  currency: "USD",
  client_id: "EOJ2S-Z6OoN_le_KS1d75wsZ6y0SFdVsY9183IvxFyZp",
  secret: "EClusMEUk8e9ihI7ZdVLF5cZ6y0SFdVsY9183IvxFyZp",
  env: :sandbox

config :silver, :test,
  gateway: Silver.Gateway.Test,
  api_key: "123",
  currency: "USD"




