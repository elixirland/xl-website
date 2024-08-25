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
    {:ok, %Finch.Response{status: 200, body: readme()}}
  end

  def request_by_file("ECOSYSTEM.md", _name, _opts) do
    {:ok, %Finch.Response{status: 200, body: ecosystem()}}
  end

  defp readme() do
    """
    # Some Project Name
    Some text.

    ## Status
    Project: ***Not Reviewed***<br>
    Solution: ***Not Reviewed***

    > [!NOTE]
    > Some note.

    ## Introduction
    Some text.

    ## Task
    Some text.

    ## Requirements
    ### Some heading
      - Some list.

    > [!TIP]
    > Some tip.

    ## How to get started
    Some text.

    ## Example solution
    Some text.
    """
  end

  defp ecosystem() do
    """
    # The Elixir Ecosystem

    Some text about the Elixir ecosystem.

    ## The Web

    ### Phoenix Framework

    Some text about Phoenix.

    [Documentation](https://phoenix.test)

    ### Phoenix LiveView

    Some text about LiveView.

    [Documentation](https://liveview.test)

    ## Native Applications

    ### Scenic

    Some text about Scenic.

    [Documentation](https://scenic.test)

    ### LiveView Native

    Some text about LiveView Native.

    [Documentation](https://liveviewnative.test)
    """
  end
end
