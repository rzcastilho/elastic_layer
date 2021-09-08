# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

config :middleware, Middleware.MultilevelCache,
  model: :inclusive,
  levels: [
    {
      Middleware.MultilevelCache.L1,
      gc_interval: :timer.hours(12),
      max_size: 1_00_000
    },
    {
      Middleware.MultilevelCache.L2,
      primary: [
        gc_interval: :timer.hours(12),
        max_size: 1_00_000
      ]
    }
  ]

import_config "#{config_env()}.exs"
