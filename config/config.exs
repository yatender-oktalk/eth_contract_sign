import Config


config :ethereumex,
  url: System.get_env("eth_url", "https://goerli.infura.io/v3/{API_KEY}")

config :sign_web3,
  blockchain_url:
    System.get_env("eth_url", "https://goerli.infura.io/v3/{API_KEY}")
