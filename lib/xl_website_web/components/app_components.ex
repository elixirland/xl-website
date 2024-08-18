defmodule XlWebsiteWeb.AppComponents do
  use XlWebsiteWeb, :html

  attr :path, :list
  attr :github_source, :string, default: nil

  def top_navigation(assigns) do
    ~H"""
    <div class="flex items-center mb-4">
      <nav>
        <ul class="flex gap-1">
          <li class="after:content-['_/']">
            <.link class="text-[#2879c5]" href={~p"/"}>home</.link>
          </li>

          <%= for {item, index} <- Enum.with_index(@path) do %>
            <li class={if index < length(@path) - 1, do: "after:content-['_/']", else: ""}>
              <.link class="text-[#2879c5]" href={build_breadcrumb_path(@path, index)}>
                <%= item %>
              </.link>
            </li>
          <% end %>
        </ul>
      </nav>
      <%= if is_nil(@github_source) do %>
        <span class="text-[#696969c0] ml-auto disabled:opacity-50 cursor-default">
          Not yet on GitHub
        </span>
      <% else %>
        <.link class="text-[#2879c5] hover:underline ml-auto" href={@github_source}>
          View on GitHub
        </.link>
      <% end %>
    </div>
    """
  end

  defp build_breadcrumb_path(path_list, index) do
    path_list
    |> Enum.take(index + 1)
    |> Enum.join("/")
    |> then(&"/#{&1}")
  end

  attr :exercise, :map

  def exercise_card(assigns) do
    ~H"""
    <.link href={~p"/exercises/#{@exercise.slug}"} class="sm:w-full w-[360px]">
      <article class="bg-white rounded-xl overflow-clip hover:-translate-x-[2px] hover:-translate-y-[3px] transition-all shadow-md hover:shadow-lg relative">
        <%!-- TODO: Replace hard-coded status --%>
        <span class="absolute top-2 right-2 bg-[#f7f7f7f7] drop-shadow py-1 px-2 font-medium rounded-md text-[0.8rem] tracking-wide">
          <%= status(@exercise.name) %>
        </span>
        <img
          src={"/images/#{@exercise.name}.webp"}
          width="360"
          height="240"
          class="h-[240px] sm:w-full bg-cover bg-center"
        />
        <div class="p-5 flex flex-col h-[180px]">
          <h1 class="text-3xl mb-1.5 font-bold">
            <%= @exercise.name %>
          </h1>
          <p><%= @exercise.description %></p>
          <div class="mt-auto flex gap-2 flex-wrap">
            <.topic :for={topic <- @exercise.topics} topic={topic} />
          </div>
        </div>
      </article>
    </.link>
    """
  end

  defp status(repo_name) do
    case repo_name do
      _ -> "Coming Soon"
    end
  end

  attr :topic, :string

  def topic(assigns) do
    ~H"""
    <span class="bg-primary-100 text-primary-900 rounded-md px-2 py-1 text-xs bg-indigo-50">
      <%= @topic %>
    </span>
    """
  end
end
