ExUnit.start()

Mox.defmock(Elastix.HTTPMock, for: HTTPoison.Base)

Application.put_env(:middleware, :http_client, Elastix.HTTPMock)

