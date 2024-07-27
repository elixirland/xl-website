defmodule XlWebsiteWeb.HTTPClient do
  @callback build(
              Finch.Request.method(),
              Finch.Request.url(),
              Finch.Request.headers(),
              Finch.Request.body(),
              Keyword.t()
            ) :: Finch.Request.t()

  @callback request(
              Finch.Request.t(),
              Finch.name(),
              Finch.request_opts()
            ) :: Finch.Response.t()

  def build(method, url, headers \\ [], body \\ [], opts \\ []),
    do: impl().build(method, url, headers, body, opts)

  def request(request, name, opts \\ []),
    do: impl().request(request, name, opts)

  defp impl(),
    do: Application.get_env(:xl_website, :http_client, Finch)
end

defmodule FinchFake do
  alias XlWebsiteWeb.HTTPClient
  @behaviour HTTPClient

  @impl HTTPClient
  def build(method, url, headers \\ [], body \\ [], _opts \\ []) do
    %Finch.Request{
      body: body,
      headers: headers,
      host: nil,
      method: method,
      path: url,
      port: 80,
      query: nil,
      scheme: :http,
      unix_socket: nil
    }
  end

  @impl HTTPClient
  def request(_request, _name, _opts \\ []) do
    {:ok, %Finch.Response{status: 200, body: "mocked response"}}
  end
end
