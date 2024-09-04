defmodule XlWebsiteWeb.AppComponents do
  use XlWebsiteWeb, :html

  attr :markdown, :string, required: true

  def markdown(assigns) do
    safe_html =
      assigns.markdown
      |> Earmark.as_html!()
      |> HtmlSanitizeEx.basic_html()
      |> parse_github_icons()
      |> raw()

    assigns = assign(assigns, safe_html: safe_html)

    ~H"""
    <%= @safe_html %>
    """
  end

  attr :path, :list
  attr :github_source, :string, default: nil

  def top_navigation(assigns) do
    ~H"""
    <div class="flex items-center mb-4">
      <nav>
        <ul class="flex gap-1">
          <li class="after:content-['_/']">
            <.link class="text-[#2879c5] dark:text-blue-400" href={~p"/"}>home</.link>
          </li>

          <%= for {item, index} <- Enum.with_index(@path) do %>
            <li class={if index < length(@path) - 1, do: "after:content-['_/']", else: ""}>
              <.link
                class="text-[#2879c5] dark:text-blue-400"
                href={build_breadcrumb_path(@path, index)}
              >
                <%= item %>
              </.link>
            </li>
          <% end %>
        </ul>
      </nav>
      <.link :if={@github_source} class="ml-auto" href={@github_source}>
        <img
          src="/images/icons/github-logo.svg"
          width="24"
          height="24"
          alt="GitHub"
          class="dark:hidden"
        />
        <img
          src="/images/icons/github-logo-white.svg"
          width="24"
          height="24"
          alt="GitHub"
          class="hidden dark:block"
        />
      </.link>
    </div>
    """
  end

  defp build_breadcrumb_path(path_list, index) do
    path_list
    |> Enum.take(index + 1)
    |> Enum.join("/")
    |> then(&"/#{&1}")
  end

  attr :project, :map

  def project_card(assigns) do
    ~H"""
    <.link href={~p"/projects/#{@project.slug}"} class="sm:w-full w-[360px]">
      <article class="bg-white dark:bg-[#323232] rounded-lg overflow-clip transition-all shadow-md relative">
        <%!-- Display and play behavior is defined in assets/js/card_media.js --%>
        <div class="aspect-[3/2] relative" data-card-media>
          <img
            src={"https://github.com/#{@project.full_name}/raw/main/thumbnail_small.webp"}
            onerror={"this.onerror=null;this.src='https://github.com/#{@project.full_name}/raw/main/thumbnail_small.webp'"}
            width="360"
            height="240"
            class="sm:w-full bg-cover bg-center"
          />
          <video width="360" height="240" loop muted class="hidden w-full">
            <source
              src={"https://github.com/#{@project.full_name}/raw/main/preview.webm"}
              type="video/webm"
            /> Your browser does not support the video tag.
          </video>
        </div>

        <div class="p-5 flex flex-col h-[180px]">
          <h1 class="text-3xl mb-1.5 font-bold">
            <%= @project.name %>
          </h1>
          <p><%= @project.description %></p>
          <div class="mt-auto flex gap-2 flex-wrap">
            <.topic :for={topic <- @project.topics} topic={topic} />
          </div>
        </div>
      </article>
    </.link>
    """
  end

  attr :topic, :string

  def topic(assigns) do
    ~H"""
    <span class="bg-primary-100 text-primary-900 rounded-md px-2 py-1 text-xs bg-indigo-50 dark:bg-indigo-600">
      <%= @topic %>
    </span>
    """
  end

  attr :tool, :map

  def ecosystem_tool_card(assigns) do
    ~H"""
    <article class="bg-white dark:bg-[#323232] rounded-xl overflow-clip shadow-md">
      <div class="p-8">
        <img
          src={"https://raw.githubusercontent.com/elixirland/ecosystem/main/thumbnails/#{@tool.name}.webp"}
          onerror="this.style.display='none'"
          height="60"
          class="h-[60px] bg-cover bg-center float-right bg-white rounded-lg p-2"
        />
        <h1 class="text-2xl font-semibold mb-0.5"><%= @tool.name %></h1>
        <div class="max-w-[65ch]" data-markdown="project">
          <%= raw(Earmark.as_html!(@tool.description)) %>
        </div>
      </div>
    </article>
    """
  end

  defp parse_github_icons(html) do
    html
    |> String.replace(
      ~r/\[!NOTE\]/,
      "<span data-icon='note' class='hero-information-circle-solid h-6 w-6 mr-2 text-blue-600'></span>"
    )
    |> String.replace(
      ~r/\[!TIP\]/,
      "<span data-icon='tip' class='hero-information-circle-solid h-6 w-6 mr-2 text-green-700'></span>"
    )
    |> String.replace(
      ~r/\[!IMPORTANT\]/,
      "<span data-icon='important' class='hero-exclamation-circle-solid h-6 w-6 mr-2 text-purple-700'></span>"
    )
    |> String.replace(
      ~r/\[!WARNING\]/,
      "<span data-icon='warning' class='hero-exclamation-triangle-solid h-6 w-6 mr-2 text-yellow-600'></span>"
    )
    |> String.replace(
      ~r/\[!CAUTION\]/,
      "<span data-icon='caution' class='hero-exclamation-triangle-solid h-6 w-6 mr-2 text-red-600'></span>"
    )
  end
end
