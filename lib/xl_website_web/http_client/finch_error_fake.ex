defmodule FinchErrorFake do
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

  def request(request, name, opts \\ [])

  @impl HTTPClient
  def request(request, name, opts) do
    file =
      request.path
      |> String.split("/")
      |> List.last()

    request_by_file(file, name, opts)
  end

  def request_by_file("README.md", _name, _opts) do
    {:ok, %Finch.Response{status: 404}}
  end

  def request_by_file("ECOSYSTEM.md", _name, _opts) do
    {:ok, %Finch.Response{status: 404}}
  end
end
