defmodule Middleware.MultilevelCache do
  use Nebulex.Cache,
    otp_app: :middleware,
    adapter: Nebulex.Adapters.Multilevel

  defmodule L1 do
    use Nebulex.Cache,
      otp_app: :middleware,
      adapter: Nebulex.Adapters.Local
  end

  defmodule L2 do
    use Nebulex.Cache,
      otp_app: :middleware,
      adapter: Nebulex.Adapters.Partitioned
  end

end
