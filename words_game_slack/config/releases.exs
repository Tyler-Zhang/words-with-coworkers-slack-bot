# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
import Config

defmodule ReleaseHelper do
  def env_or_raise(env, message \\ "") do
    System.get_env(env) || raise "ENV variable #{env} missing\n#{message}"
  end
end

database_url = ReleaseHelper.env_or_raise(
  "DATABASE_URL",
  "For example: ecto://USER:PASS@HOST/DATABASE")

config :words_game_slack, WordsGameSlack.Repo,
  # ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

secret_key_base = ReleaseHelper.env_or_raise(
  "SECRET_KEY_BASE",
  "You can generate one by calling: mix phx.gen.secret")

config :words_game_slack, WordsGameSlackWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
config :words_game_slack, WordsGameSlackWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.

config :words_game_slack, :slack_oauth,
  app_id: ReleaseHelper.env_or_raise("SLACK_APP_ID"),
  client_id: ReleaseHelper.env_or_raise("SLACK_CLIENT_ID"),
  client_secret: ReleaseHelper.env_or_raise("SLACK_CLIENT_SECRET"),
  signing_secret: ReleaseHelper.env_or_raise("SLACK_SIGNING_SECRET")
