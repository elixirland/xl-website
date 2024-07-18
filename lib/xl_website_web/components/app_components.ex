defmodule XlWebsiteWeb.AppComponents do
  use Phoenix.Component

  attr :repo, :map

  def assignment(assigns) do
    ~H"""
    <.link href={@repo.html_url}>
      <article class="w-[360px] bg-white rounded-xl overflow-clip hover:-translate-x-[2px] hover:-translate-y-[3px] transition-all shadow-md hover:shadow-lg">
        <img
          src={"/images/book-club.png"}
          width="400"
          height="240"
          class="h-[240px] bg-contain bg-center"
        />
        <div class="p-4 flex flex-col h-[180px]">
          <h1 class="text-3xl mb-1.5 font-medium">
            <%= @repo.name %>
          </h1>
          <p><%= @repo.description %></p>
          <div class="mt-auto flex gap-2 flex-wrap">
            <.topic
              :for={topic <- @repo.topics}
              topic={topic}
            />
          </div>
        </div>
      </article>
    </.link>
    """
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
